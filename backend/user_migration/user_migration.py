import os
import psycopg2
import boto3
from dotenv import load_dotenv

load_dotenv()

# Database configuration
db_config = {
    'host': os.getenv('DB_HOST'),
    'dbname': os.getenv('DB_NAME'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'port': os.getenv('DB_PORT', 5432)
}

# AWS Cognito configuration
COGNITO_POOL_ID = os.getenv("COGNITO_USER_POOL_ID")
COGNITO_REGION = os.getenv("COGNITO_REGION")
COGNITO_APP_CLIENT_ID = os.getenv("COGNITO_APP_CLIENT_ID")

# Initialize AWS Cognito client
client = boto3.client('cognito-idp', region_name=COGNITO_REGION)

# Database connection
def get_db_connection():
    try:
        conn = psycopg2.connect(**db_config)
        return conn
    except Exception as e:
        print(f"Database connection error: {e}")
        raise

# Fetch user from internal database
def get_user_from_db(username):
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT id, email, password FROM users WHERE username = %s", (username,))
                return cur.fetchone()
    except Exception as e:
        print(f"Error fetching user {username}: {e}")
        return None

# Migrate user to Cognito
def migrate_user(event, context):
    username = event['userName']
    password = event['request']['password']

    # Check if user exists in internal database
    user = get_user_from_db(username)
    if not user:
        print(f"User {username} not found in internal database.")
        raise Exception("User not found.")

    user_id, email, stored_password = user

    # Verify password
    if password != stored_password:
        print(f"Password mismatch for user {username}.")
        raise Exception("Invalid credentials.")

    # Prepare user attributes for Cognito
    user_attributes = {
        'username': username,
        'email': email,
        'email_verified': 'true'
    }

    # Create user in Cognito
    try:
        response = client.admin_create_user(
            UserPoolId=COGNITO_POOL_ID,
            Username=username,
            UserAttributes=[{'Name': key, 'Value': value} for key, value in user_attributes.items()],
            MessageAction='SUPPRESS'  # Suppress welcome message
        )
        print(f"User {username} migrated successfully.")
        return response
    except client.exceptions.UsernameExistsException:
        print(f"User {username} already exists in Cognito.")
        return None
    except Exception as e:
        print(f"Error migrating user {username}: {e}")
        raise
