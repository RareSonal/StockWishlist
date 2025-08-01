import os
import psycopg2
from dotenv import load_dotenv
import json

load_dotenv()

# DB config
db_config = {
    'host': os.getenv('DB_HOST'),
    'dbname': os.getenv('DB_NAME'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'port': os.getenv('DB_PORT', 5432)
}


def get_db_connection():
    return psycopg2.connect(**db_config)


def get_user_by_email(email):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT id, email, password FROM users WHERE LOWER(email) = LOWER(%s)", (email,))
                return cur.fetchone()
    except Exception as e:
        print(f"[DB] Error fetching user {email}: {e}")
        return None


def lambda_handler(event, context):
    print("Received event:", json.dumps(event))

    email = event.get('userName')
    input_password = event['request'].get('password')

    print(f"Raw email input: '{email}'")
    print(f"Password input: '{input_password}'")

    if not email or not input_password:
        print("[Error] Missing email or password in request")
        raise Exception("Missing email or password")

    user = get_user_by_email(email)

    print(f"DB result for '{email}': {user}")  
    
    if not user:
        print(f"[Error] User '{email}' not found in DB.")
        raise Exception("User not found")

    user_id, user_email, stored_password = user

    if stored_password != input_password:
        print(f"[Auth] Invalid password for user '{email}'.")
        raise Exception("Invalid credentials")

    print(f"[Success] User '{email}' authenticated and ready for migration.")

    event['response'] = {
        "userAttributes": {
            "email": user_email,
            "email_verified": "true"  # optional but useful
        },
        "finalUserStatus": "CONFIRMED",
        "messageAction": "SUPPRESS",
        "desiredDeliveryMediums": ["EMAIL"],
        "forceAliasCreation": False
    }

    return event
