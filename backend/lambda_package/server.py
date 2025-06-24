import os
import sys
import json
import logging
import psycopg2
from jose import jwt, JWTError
from jose.utils import base64url_decode
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.backends import default_backend
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
        raise RuntimeError(f"Missing required environment variable: {name}")
    return value

db_config = {
    'host': get_env_var('DB_HOST'),
    'dbname': get_env_var('DB_NAME'),
    'user': get_env_var('DB_USER'),
    'password': get_env_var('DB_PASSWORD'),
    'port': int(get_env_var('DB_PORT', required=False, default=5432))
}

COGNITO_USER_POOL_ID   = get_env_var("COGNITO_USER_POOL_ID")
COGNITO_APP_CLIENT_ID  = get_env_var("COGNITO_APP_CLIENT_ID")
COGNITO_REGION         = get_env_var("COGNITO_REGION")

COGNITO_ISSUER = f"https://cognito-idp.{COGNITO_REGION}.amazonaws.com/{COGNITO_USER_POOL_ID}"
JWKS_FILE = os.path.join(os.path.dirname(__file__), 'jwks.json')

# --- Load JWKS from local file ---
try:
    with open(JWKS_FILE, 'r') as f:
        JWKS_KEYS = json.load(f).get('keys', [])
    app.logger.info("✅ Loaded JWKS from jwks.json")
except Exception as e:
    app.logger.error(f"❌ Failed loading jwks.json: {e}")
    JWKS_KEYS = []

def get_public_key(token):
    headers = jwt.get_unverified_header(token)
    kid = headers.get('kid')
    for key in JWKS_KEYS:
        if key.get('kid') == kid:
            n = int.from_bytes(base64url_decode(key['n']), byteorder='big')
            e = int.from_bytes(base64url_decode(key['e']), byteorder='big')
            public_numbers = rsa.RSAPublicNumbers(e, n)
            public_key = public_numbers.public_key(default_backend())
            return public_key
    raise JWTError("Public key not found in JWKS")

def verify_token(token):
    try:
        key = get_public_key(token)
        pem_key = key.public_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PublicFormat.SubjectPublicKeyInfo
        )
        return jwt.decode(
            token,
            pem_key,
            algorithms=['RS256'],
            audience=COGNITO_APP_CLIENT_ID,
            issuer=COGNITO_ISSUER
        )
    except Exception as e:
        app.logger.error(f"[Auth] Token verification error: {e}")
        raise


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
                res = cur.fetchone()
                if res:
                    return res[0]
                app.logger.warning(f"[DB] No user for email: {email}")
                return None
    except Exception as e:
        app.logger.error(f"[DB] Error retrieving user ID: {e}")
        return None

# --- Middleware ---
def login_required(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        auth_header = request.headers.get("Authorization", "")
        token = auth_header.replace("Bearer ", "")
        try:
            claims = verify_token(token)
        except Exception as e:
            app.logger.error(f"[Auth] Token verify failed: {e}")
            return jsonify({"error": "Unauthorized — invalid or expired token"}), 401

        email = claims.get("email")
        if not email:
            return jsonify({"error": "Unauthorized — token missing email"}), 401

        user_id = get_user_id_from_email(email)
        if not user_id:
            return jsonify({"error": f"User '{email}' not in DB"}), 404

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

    from boto3 import client as boto3_client
    data = request.get_json() or {}
    username = data.get("username")
    password = data.get("password")
    if not username or not password:
        return jsonify({"error": "Missing username or password"}), 400

    cognito = boto3_client('cognito-idp', region_name=COGNITO_REGION)
    try:
        resp = cognito.initiate_auth(
            ClientId=COGNITO_APP_CLIENT_ID,
            AuthFlow='USER_PASSWORD_AUTH',
            AuthParameters={'USERNAME': username, 'PASSWORD': password}
        )
        auth = resp.get('AuthenticationResult', {})
        return jsonify({
            "message": "Login successful",
            "id_token": auth.get('IdToken'),
            "access_token": auth.get('AccessToken'),
            "refresh_token": auth.get('RefreshToken')
        }), 200
    except cognito.exceptions.NotAuthorizedException:
        return jsonify({"error": "Invalid credentials"}), 401
    except Exception as e:
        app.logger.error(f"[Auth] Login error: {e}")
        return jsonify({"error": "Login failed"}), 500

@app.route('/v1/stocks', methods=['GET'])
@login_required
def get_stocks():
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM Stocks WHERE quantity > 0")
                rows = cur.fetchall()
                cols = [d[0] for d in cur.description]
                return jsonify([dict(zip(cols, r)) for r in rows])
    except Exception as e:
        app.logger.error(f"[DB] fetch stocks failed: {e}")
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
                cols = [d[0] for d in cur.description]
                return jsonify([dict(zip(cols, r)) for r in rows])
    except Exception as e:
        app.logger.error(f"[DB] fetch wishlist failed: {e}")
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
                cur.execute("INSERT INTO Wishlist(user_id, stock_id) VALUES(%s, %s)",
                            (request.user_id, stock_id))
                cur.execute("UPDATE Stocks SET quantity = quantity - 1 WHERE id = %s", (stock_id,))
                conn.commit()
                return jsonify({'message': 'Stock added to wishlist'}), 200
    except Exception as e:
        app.logger.error(f"[DB] add wishlist failed: {e}")
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
                cur.execute("DELETE FROM Wishlist WHERE user_id=%s AND stock_id=%s",
                            (request.user_id, stock_id))
                cur.execute("UPDATE Stocks SET quantity = quantity + 1 WHERE id = %s", (stock_id,))
                conn.commit()
                return jsonify({'message': 'Stock removed from wishlist'}), 200
    except Exception as e:
        app.logger.error(f"[DB] remove wishlist failed: {e}")
        return jsonify({'error': 'Failed to remove from wishlist'}), 500

@app.route('/<path:path>', methods=['OPTIONS'])
def catch_all_options(path):
    return '', 204

# --- Lambda Entry Point ---
def handler(event, context):
    return awsgi2.response(app, event, context)
