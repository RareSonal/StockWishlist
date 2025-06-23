import os
import sys
import jwt
import requests
import boto3
import psycopg2
import logging

from flask import Flask, request, jsonify
from flask_cors import CORS
from functools import wraps
import awsgi2

# --- Flask App Setup ---
app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)
app.logger.addHandler(logging.StreamHandler(sys.stdout))
app.logger.setLevel(logging.INFO)

# --- Configuration ---
def get_env_var(name, required=True, default=None):
    value = os.getenv(name, default)
    if required and not value:
        app.logger.error(f"Missing required environment variable: {name}")
        raise RuntimeError(f"Missing environment variable: {name}")
    return value

db_config = {
    'host': get_env_var('DB_HOST'),
    'dbname': get_env_var('DB_NAME'),
    'user': get_env_var('DB_USER'),
    'password': get_env_var('DB_PASSWORD'),
    'port': int(get_env_var('DB_PORT', required=False, default=5432))
}

COGNITO_REGION = get_env_var("COGNITO_REGION")
COGNITO_POOL_ID = get_env_var("COGNITO_USER_POOL_ID")
COGNITO_APP_CLIENT_ID = get_env_var("COGNITO_APP_CLIENT_ID")
JWKS_URL = f"https://cognito-idp.{COGNITO_REGION}.amazonaws.com/{COGNITO_POOL_ID}/.well-known/jwks.json"

# -- Rest of the file remains unchanged --
# All the route definitions and handlers stay the same.

# --- Database Utilities ---
def get_db_connection():
    try:
        return psycopg2.connect(**db_config)
    except Exception as e:
        app.logger.error(f"[DB] Connection failed: {e}")
        raise

def get_user_id_from_email(email):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT id FROM users WHERE email = %s", (email,))
                result = cur.fetchone()
                if result:
                    return result[0]
                app.logger.warning(f"[DB] No user found for email: {email}")
                return None
    except Exception as e:
        app.logger.error(f"[DB] Error retrieving user ID: {e}")
        return None

# --- Auth Utilities ---
def get_jwks():
    try:
        response = requests.get(JWKS_URL, timeout=3)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        app.logger.error(f"[Auth] Failed to fetch JWKS: {e}")
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
        return jwt.decode(
            token,
            public_key,
            algorithms=["RS256"],
            audience=COGNITO_APP_CLIENT_ID,
            issuer=f"https://cognito-idp.{COGNITO_REGION}.amazonaws.com/{COGNITO_POOL_ID}"
        )
    except Exception as e:
        app.logger.error(f"[Auth] Token decode failed: {e}")
        return None

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
        app.logger.warning("[Auth] Invalid username or password")
        return None
    except Exception as e:
        app.logger.error(f"[Auth] Error during authentication: {e}")
        return None

# --- Middleware ---
def login_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        auth_header = request.headers.get("Authorization", "")
        token = auth_header.replace("Bearer ", "")

        user = decode_token(token)
        if not user:
            return jsonify({"error": "Unauthorized – invalid or expired token"}), 401

        email = user.get("email")
        if not email:
            return jsonify({"error": "Unauthorized – email not present in token"}), 401

        user_id = get_user_id_from_email(email)
        if not user_id:
            return jsonify({"error": f"User with email '{email}' not found in DB"}), 404

        request.user_id = user_id
        return f(*args, **kwargs)
    return wrapper

# --- Routes ---
@app.route('/', methods=['GET'])
def health_check():
    return jsonify({'message': 'Server is running'})

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
        tokens = response['AuthenticationResult']
        return jsonify({
            "message": "Login successful",
            "id_token": tokens['IdToken'],
            "access_token": tokens['AccessToken'],
            "refresh_token": tokens.get('RefreshToken')
        }), 200
    else:
        return jsonify({"error": "Invalid credentials"}), 401

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
        app.logger.error(f"[DB] Error fetching stocks: {e}")
        return jsonify({'error': 'Failed to retrieve stocks'}), 500

@app.route('/v1/wishlist', methods=['GET'])
@login_required
def get_wishlist():
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT w.user_id, s.id AS stock_id, s.name
                    FROM Wishlist w
                    JOIN Stocks s ON w.stock_id = s.id
                    WHERE w.user_id = %s
                """, (request.user_id,))
                rows = cur.fetchall()
                colnames = [desc[0] for desc in cur.description]
                return jsonify([dict(zip(colnames, row)) for row in rows])
    except Exception as e:
        app.logger.error(f"[DB] Error fetching wishlist: {e}")
        return jsonify({'error': 'Failed to retrieve wishlist'}), 500

@app.route('/v1/wishlist', methods=['POST'])
@login_required
def add_to_wishlist():
    stock_id = request.get_json().get('stock_id')
    if not stock_id:
        return jsonify({'error': 'Missing stock_id'}), 400

    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT quantity FROM Stocks WHERE id = %s", (stock_id,))
                row = cur.fetchone()
                if not row or row[0] <= 0:
                    return jsonify({'error': 'Stock not available'}), 400

                cur.execute("INSERT INTO Wishlist (user_id, stock_id) VALUES (%s, %s)", (request.user_id, stock_id))
                cur.execute("UPDATE Stocks SET quantity = quantity - 1 WHERE id = %s", (stock_id,))
                conn.commit()
                return jsonify({'message': 'Stock added to wishlist'}), 200
    except Exception as e:
        app.logger.error(f"[DB] Error adding stock to wishlist: {e}")
        return jsonify({'error': 'Failed to add to wishlist'}), 500

@app.route('/v1/wishlist', methods=['DELETE'])
@login_required
def remove_from_wishlist():
    stock_id = request.get_json().get('stock_id')
    if not stock_id:
        return jsonify({'error': 'Missing stock_id'}), 400

    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("DELETE FROM Wishlist WHERE user_id = %s AND stock_id = %s", (request.user_id, stock_id))
                cur.execute("UPDATE Stocks SET quantity = quantity + 1 WHERE id = %s", (stock_id,))
                conn.commit()
                return jsonify({'message': 'Stock removed from wishlist'}), 200
    except Exception as e:
        app.logger.error(f"[DB] Error removing stock from wishlist: {e}")
        return jsonify({'error': 'Failed to remove from wishlist'}), 500

@app.route('/<path:path>', methods=['OPTIONS'])
def catch_all_options(path):
    return '', 204

# --- Lambda Entry Point ---
def handler(event, context):
    return awsgi2.response(app, event, context)


