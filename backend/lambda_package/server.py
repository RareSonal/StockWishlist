import sys
import os
import jwt
import requests
import boto3
import psycopg2
import logging
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
from functools import wraps

# Load environment variables and configure logging
load_dotenv()
logging.basicConfig(level=logging.INFO)

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)
app.logger.addHandler(logging.StreamHandler(sys.stdout))
app.logger.setLevel(logging.INFO)

# Database configuration
db_config = {
    'host': os.getenv('DB_HOST'),
    'dbname': os.getenv('DB_NAME'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'port': os.getenv('DB_PORT', 5432)
}

# Cognito config
COGNITO_POOL_ID = os.getenv("COGNITO_USER_POOL_ID")
COGNITO_REGION = os.getenv("COGNITO_REGION")
COGNITO_APP_CLIENT_ID = os.getenv("COGNITO_APP_CLIENT_ID")
JWKS_URL = f"https://cognito-idp.{COGNITO_REGION}.amazonaws.com/{COGNITO_POOL_ID}/.well-known/jwks.json"

# Add CORS headers to every response
@app.after_request
def apply_cors_headers(response):
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type,Authorization'
    response.headers['Access-Control-Allow-Methods'] = 'GET,POST,PUT,DELETE,OPTIONS'
    return response

# --- Helper Functions ---

def authenticate_user(username, password):
    try:
        client = boto3.client('cognito-idp', region_name=COGNITO_REGION)
        response = client.initiate_auth(
            ClientId=COGNITO_APP_CLIENT_ID,
            AuthFlow='USER_PASSWORD_AUTH',
            AuthParameters={
                'USERNAME': username,
                'PASSWORD': password
            }
        )
        return response
    except client.exceptions.NotAuthorizedException:
        app.logger.warning("Invalid username or password")
        return None
    except Exception as e:
        app.logger.error(f"Error during authentication: {e}")
        return None

def get_jwks():
    try:
        resp = requests.get(JWKS_URL, timeout=3)
        return resp.json()
    except Exception as e:
        app.logger.error(f"Failed to fetch JWKS: {e}")
        return None

def decode_token(token):
    try:
        jwks = get_jwks()
        if not jwks or "keys" not in jwks:
            raise Exception("Invalid JWKS")

        headers = jwt.get_unverified_header(token)
        kid = headers["kid"]
        key = next((k for k in jwks["keys"] if k["kid"] == kid), None)
        if not key:
            raise Exception("Public key not found in JWKS")

        public_key = jwt.algorithms.RSAAlgorithm.from_jwk(key)
        decoded = jwt.decode(
            token,
            public_key,
            algorithms=["RS256"],
            audience=COGNITO_APP_CLIENT_ID,
            issuer=f"https://cognito-idp.{COGNITO_REGION}.amazonaws.com/{COGNITO_POOL_ID}"
        )
        return decoded
    except Exception as e:
        app.logger.error(f"Token decode error: {e}")
        return None

def get_db_connection():
    try:
        return psycopg2.connect(**db_config)
    except Exception as e:
        app.logger.error(f"Database connection error: {e}")
        raise

def get_user_id_from_email(email):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT id FROM users WHERE email = %s", (email,))
                result = cur.fetchone()
                return result[0] if result else None
    except Exception as e:
        app.logger.error(f"Error fetching user ID for email {email}: {e}")
        return None

def login_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        auth_header = request.headers.get("Authorization", "")
        token = auth_header.replace("Bearer ", "")
        user = decode_token(token)
        if not user:
            return jsonify({"error": "Unauthorized"}), 401

        email = user.get("email")
        user_id = get_user_id_from_email(email)
        if not user_id:
            return jsonify({"error": "User not found"}), 404

        request.user_id = user_id
        return f(*args, **kwargs)
    return wrapper

# --- Routes ---

@app.route('/v1/login', methods=['POST', 'OPTIONS'])
def login():
    if request.method == 'OPTIONS':
        return '', 200

    data = request.get_json()
    username = data.get("username")
    password = data.get("password")

    if not username or not password:
        return jsonify({"error": "Missing username or password"}), 400

    response = authenticate_user(username, password)
    if response:
        return jsonify({
            "message": "Login successful",
            "id_token": response['AuthenticationResult']['IdToken'],
            "access_token": response['AuthenticationResult']['AccessToken'],
            "refresh_token": response['AuthenticationResult'].get('RefreshToken')
        }), 200
    else:
        return jsonify({"error": "Invalid credentials"}), 401

@app.route('/v1/login', methods=['GET'])
def login_get_not_allowed():
    return jsonify({"error": "GET method not allowed on /v1/login. Use POST."}), 405

@app.route('/favicon.ico', methods=['GET'])
def favicon():
    return '', 204

@app.route('/v1/stocks', methods=['GET'])
@login_required
def get_stocks():
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM Stocks WHERE quantity > 0")
                rows = cur.fetchall()
                colnames = [desc[0] for desc in cur.description]
                return jsonify([dict(zip(colnames, row)) for row in rows])
    except Exception as e:
        app.logger.error(f"Error fetching stocks: {e}")
        return jsonify({'error': 'Error fetching stocks'}), 500

@app.route('/v1/wishlist', methods=['GET'])
@login_required
def get_wishlist():
    user_id = request.user_id
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT w.user_id, s.id AS stock_id, s.name
                    FROM Wishlist w
                    JOIN Stocks s ON w.stock_id = s.id
                    WHERE w.user_id = %s
                """, (user_id,))
                rows = cur.fetchall()
                colnames = [desc[0] for desc in cur.description]
                return jsonify([dict(zip(colnames, row)) for row in rows])
    except Exception as e:
        app.logger.error(f"Error fetching wishlist: {e}")
        return jsonify({'error': 'Error fetching wishlist'}), 500

@app.route('/v1/wishlist', methods=['POST'])
@login_required
def add_to_wishlist():
    user_id = request.user_id
    stock_id = request.get_json().get('stock_id')

    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT quantity FROM Stocks WHERE id = %s", (stock_id,))
                row = cur.fetchone()
                if not row or row[0] <= 0:
                    return jsonify({'error': 'Stock not available'}), 400

                cur.execute("INSERT INTO Wishlist (user_id, stock_id) VALUES (%s, %s)", (user_id, stock_id))
                cur.execute("UPDATE Stocks SET quantity = quantity - 1 WHERE id = %s", (stock_id,))
                conn.commit()
                return jsonify({'message': 'Stock added to wishlist'}), 200
    except Exception as e:
        app.logger.error(f"Error adding to wishlist: {e}")
        return jsonify({'error': 'Error adding to wishlist'}), 500

@app.route('/v1/wishlist', methods=['DELETE'])
@login_required
def remove_from_wishlist():
    user_id = request.user_id
    stock_id = request.get_json().get('stock_id')

    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("DELETE FROM Wishlist WHERE user_id = %s AND stock_id = %s", (user_id, stock_id))
                cur.execute("UPDATE Stocks SET quantity = quantity + 1 WHERE id = %s", (stock_id,))
                conn.commit()
                return jsonify({'message': 'Stock removed from wishlist'}), 200
    except Exception as e:
        app.logger.error(f"Error removing from wishlist: {e}")
        return jsonify({'error': 'Error removing from wishlist'}), 500

@app.route('/', methods=['GET'])
def health_check():
    return jsonify({'message': 'Server is running'})

@app.route('/<path:path>', methods=['OPTIONS'])
def catch_all_options(path):
    return '', 204
