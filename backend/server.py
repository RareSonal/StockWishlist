from flask import Flask, request, jsonify
from flask_cors import CORS
import pyodbc
import os
from dotenv import load_dotenv

app = Flask(__name__)
CORS(app)

load_dotenv()

db_config = {
    'server': os.getenv('DB_SERVER'),
    'database': os.getenv('DB_NAME'),
    'username': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'driver': '{ODBC Driver 17 for SQL Server}'
}

if not all(db_config.values()):
    raise ValueError("One or more environment variables are missing")

def get_connection():
    conn_str = (
        f"DRIVER={db_config['driver']};"
        f"SERVER={db_config['server']};"
        f"DATABASE={db_config['database']};"
        f"UID={db_config['username']};"
        f"PWD={db_config['password']};"
        f"Encrypt=yes;TrustServerCertificate=yes"
    )
    return pyodbc.connect(conn_str)


@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({"success": False, "message": "Email and password required"}), 400

    try:
        with get_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT id FROM Users WHERE email = ? AND password = ?", email, password)
            user = cursor.fetchone()
            if user:
                return jsonify({"success": True})
            else:
                return jsonify({"success": False}), 401
    except Exception as e:
        app.logger.error(f"Login error: {e}")
        return jsonify({"success": False, "message": "Server error"}), 500

@app.route('/stocks', methods=['GET'])
def get_stocks():
    try:
        with get_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM Stocks WHERE quantity > 0")
            columns = [column[0] for column in cursor.description]
            results = [dict(zip(columns, row)) for row in cursor.fetchall()]
            return jsonify(results)
    except Exception as e:
        app.logger.error(f"Error fetching stocks: {e}")
        return {'error': 'Error fetching stocks'}, 500

@app.route('/wishlist', methods=['GET'])
def get_wishlist():
    try:
        with get_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("""
                SELECT w.user_id, s.id as stock_id, s.name 
                FROM Wishlist w 
                JOIN Stocks s ON w.stock_id = s.id
            """)
            columns = [column[0] for column in cursor.description]
            results = [dict(zip(columns, row)) for row in cursor.fetchall()]
            return jsonify(results)
    except Exception as e:
        app.logger.error(f"Error fetching wishlist: {e}")
        return {'error': 'Error fetching wishlist'}, 500

@app.route('/wishlist', methods=['POST'])
def add_to_wishlist():
    data = request.get_json()
    user_id = data.get('user_id')
    stock_id = data.get('stock_id')

    try:
        with get_connection() as conn:
            cursor = conn.cursor()

            # Check stock availability
            cursor.execute("SELECT quantity FROM Stocks WHERE id = ?", stock_id)
            row = cursor.fetchone()

            if not row or row[0] <= 0:
                return {'error': 'Stock not available'}, 400

            # Insert into wishlist
            cursor.execute("INSERT INTO Wishlist (user_id, stock_id) VALUES (?, ?)", user_id, stock_id)

            # Decrease stock quantity
            cursor.execute("UPDATE Stocks SET quantity = quantity - 1 WHERE id = ?", stock_id)

            conn.commit()
            return {'message': 'Stock added to wishlist'}, 200

    except Exception as e:
        app.logger.error(f"Error adding stock to wishlist: {e}")
        return {'error': 'Error adding stock to wishlist'}, 500

@app.route('/wishlist', methods=['DELETE'])
def remove_from_wishlist():
    data = request.get_json()
    user_id = data.get('user_id')
    stock_id = data.get('stock_id')

    try:
        with get_connection() as conn:
            cursor = conn.cursor()

            # Remove from wishlist
            cursor.execute("DELETE FROM Wishlist WHERE user_id = ? AND stock_id = ?", user_id, stock_id)

            # Increase stock quantity
            cursor.execute("UPDATE Stocks SET quantity = quantity + 1 WHERE id = ?", stock_id)

            conn.commit()
            return {'message': 'Stock removed from wishlist'}, 200

    except Exception as e:
        app.logger.error(f"Error removing stock from wishlist: {e}")
        return {'error': 'Error removing stock from wishlist'}, 500

if __name__ == '__main__':
    port = int(os.getenv("PORT", 5000))
    app.run(host='0.0.0.0', port=port, debug=True)
