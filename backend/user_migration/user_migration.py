import os
import psycopg2
import boto3
from dotenv import load_dotenv

load_dotenv()

# DB config
db_config = {
    'host': os.getenv('DB_HOST'),
    'dbname': os.getenv('DB_NAME'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'port': os.getenv('DB_PORT', 5432)
}

# Cognito region (still from env, as region remains static in most deployments)
COGNITO_REGION = os.getenv("COGNITO_REGION")

client = boto3.client('cognito-idp', region_name=COGNITO_REGION)

def get_db_connection():
    return psycopg2.connect(**db_config)

def get_user_from_db(username):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT id, email, password FROM users WHERE username = %s", (username,))
                return cur.fetchone()
    except Exception as e:
        print(f"[DB] Error fetching user {username}: {e}")
        return None

def migrate_user(event, context):
    username = event['userName']
    password = event['request']['password']

    # 🔁 Get Cognito Pool ID from event payload
    COGNITO_POOL_ID = event.get("userPoolId")
    if not COGNITO_POOL_ID:
        print("[Error] Missing Cognito User Pool ID in event payload.")
        raise Exception("Missing Cognito User Pool ID.")

    user = get_user_from_db(username)
    if not user:
        print(f"[Error] User '{username}' not found in DB.")
        raise Exception("User not found")

    user_id, email, stored_password = user

    if password != stored_password:
        print(f"[Auth] Invalid password for user '{username}'.")
        raise Exception("Invalid credentials")

    try:
        # Step 1: Create user without sending welcome email
        client.admin_create_user(
            UserPoolId=COGNITO_POOL_ID,
            Username=username,
            UserAttributes=[
                {'Name': 'email', 'Value': email},
                {'Name': 'email_verified', 'Value': 'true'}
            ],
            MessageAction='SUPPRESS'
        )

        # Step 2: Set permanent password
        client.admin_set_user_password(
            UserPoolId=COGNITO_POOL_ID,
            Username=username,
            Password=password,
            Permanent=True
        )

        print(f"[Success] User '{username}' migrated to Cognito.")
        return event

    except client.exceptions.UsernameExistsException:
        print(f"[Info] User '{username}' already exists in Cognito. Skipping.")
        return event

    except Exception as e:
        print(f"[Error] Failed to migrate user '{username}': {e}")
        raise
