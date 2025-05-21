import sys
from flask import Flask, request, jsonify
from flask_cors import CORS
import psycopg2-binary
import os
import jwt
import requests
from dotenv import load_dotenv
from functools import wraps
import logging

# Initialize environment variables and logging
load_dotenv()
logging.basicConfig(level=logging.INFO)

app = Flask(__name__)
CORS(app)

app.logger.addHandler(logging.StreamHandler(sys.stdout))
app.logger.setLevel(logging.INFO)

# Database configuration from environment variables
db_config = {
    'host': os.getenv('DB_HOST'),
    'dbname': os.getenv('DB_NAME'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'port': os.getenv('DB_PORT', 5432)
}

COGNITO_POOL_ID = os.getenv("COGNITO_USER_POOL_ID")
COGNITO_REGION = os.getenv("COGNITO_REGION")
COGNITO_APP_CLIENT_ID = os.getenv("COGNITO_APP_CLIENT_ID")

JWKS_URL = f"https://cognito-idp.{COGNITO_REGION}.amazonaws.com/{COGNITO_POOL_ID}/.well-known/jwks.json"

# Safe JWKS fetcher with error handling
def get_jwks():
    try:
        resp = requests.get(JWKS_URL, timeout=3)
        return resp.json()
    except Exception as e:
        app.logger.error(f"Failed to fetch JWKS: {e}")
        return None

JWKS = get_jwks()

def get_db_connection():
    try:
        conn = psycopg2.connect(**db_config)
        return conn
    except Exception as e:
        app.logger.error(f"Database connection error: {e}")
        raise

def decode_token(token):
    try:
        headers = jwt.get_unverified_header(token)
        kid = headers["kid"]
        key = next((k for k in JWKS["keys"] if k["kid"] == kid), None)

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
    def decode_token(token):
    try:
        headers = jwt.get_unverified_header(token)
        kid = headers["kid"]
        key = next((k for k in JWKS["keys"] if k["kid"] == kid), None)

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

# ADD THIS AFTER decode_token() TO OVERRIDE IN TESTS
if os.getenv("FLASK_ENV") == "test":
    def decode_token(token):
        return {"sub": "test-user"}

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        auth_header = request.headers.get("Authorization", "")
        token = auth_header.replace("Bearer ", "")
        user = decode_token(token)
        if not user:
            app.logger.warning("Unauthorized access attempt")
            return jsonify({"error": "Unauthorized"}), 401
        request.user = user
        return f(*args, **kwargs)
    return decorated_function

@app.route('/stocks', methods=['GET'])
@login_required
def get_stocks():
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT * FROM Stocks WHERE quantity > 0")
                rows = cur.fetchall()
                colnames = [desc[0] for desc in cur.description]
                stocks = [dict(zip(colnames, row)) for row in rows]
        return jsonify(stocks)
    except Exception as e:
        app.logger.error(f"Error fetching stocks: {e}")
        return jsonify({'error': 'Error fetching stocks'}), 500

@app.route('/wishlist', methods=['GET'])
@login_required
def get_wishlist():
    user_sub = request.user.get("sub")
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT w.user_sub, s.id AS stock_id, s.name
                    FROM Wishlist w
                    JOIN Stocks s ON w.stock_id = s.id
                    WHERE w.user_sub = %s
                """, (user_sub,))
                rows = cur.fetchall()
                colnames = [desc[0] for desc in cur.description]
                wishlist = [dict(zip(colnames, row)) for row in rows]
        return jsonify(wishlist)
    except Exception as e:
        app.logger.error(f"Error fetching wishlist: {e}")
        return jsonify({'error': 'Error fetching wishlist'}), 500

@app.route('/wishlist', methods=['POST'])
@login_required
def add_to_wishlist():
    user_sub = request.user.get("sub")
    data = request.get_json()
    stock_id = data.get('stock_id')

    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                # Check stock availability
                cur.execute("SELECT quantity FROM Stocks WHERE id = %s", (stock_id,))
                row = cur.fetchone()
                if not row or row[0] <= 0:
                    return jsonify({'error': 'Stock not available'}), 400

                # Add to wishlist and update stock
                cur.execute("INSERT INTO Wishlist (user_sub, stock_id) VALUES (%s, %s)", (user_sub, stock_id))
                cur.execute("UPDATE Stocks SET quantity = quantity - 1 WHERE id = %s", (stock_id,))
                conn.commit()

        return jsonify({'message': 'Stock added to wishlist'}), 200
    except Exception as e:
        app.logger.error(f"Error adding to wishlist: {e}")
        return jsonify({'error': 'Error adding to wishlist'}), 500

@app.route('/wishlist', methods=['DELETE'])
@login_required
def remove_from_wishlist():
    user_sub = request.user.get("sub")
    data = request.get_json()
    stock_id = data.get('stock_id')

    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("DELETE FROM Wishlist WHERE user_sub = %s AND stock_id = %s", (user_sub, stock_id))
                cur.execute("UPDATE Stocks SET quantity = quantity + 1 WHERE id = %s", (stock_id,))
                conn.commit()

        return jsonify({'message': 'Stock removed from wishlist'}), 200
    except Exception as e:
        app.logger.error(f"Error removing from wishlist: {e}")
        return jsonify({'error': 'Error removing from wishlist'}), 500

@app.route('/')
def health_check():
    app.logger.info("Health check successful")
    return jsonify({'message': 'Server is running'})

# For AWS Lambda support
def handler(event, context): 
    import awsgi 
    return awsgi.response(app, event, context)

if __name__ == '__main__':
    port = int(os.getenv("PORT", 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
