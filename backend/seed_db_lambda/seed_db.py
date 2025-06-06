import sys
import os

# Add Lambda Layer path so Python can find packages installed in /opt/python
sys.path.append('/opt')

import psycopg2
import boto3
import traceback

lambda_client = boto3.client('lambda')
LAMBDA_FUNCTION_NAME = os.environ.get('AWS_LAMBDA_FUNCTION_NAME')

def handler(event, context):
    try:
        conn = psycopg2.connect(
            dbname="stockwishlist",
            user=os.environ["DB_USER"],
            password=os.environ["DB_PASSWORD"],
            host=os.environ["DB_HOST"]
        )

        with conn.cursor() as cur:
            # Create seed metadata table if it doesn't exist
            cur.execute("""
                CREATE TABLE IF NOT EXISTS seed_metadata (
                    key TEXT PRIMARY KEY,
                    value TEXT
                );
            """)
            conn.commit()

            # Check if seeding was already done
            cur.execute("SELECT value FROM seed_metadata WHERE key = 'db_seeded';")
            result = cur.fetchone()
            if result and result[0] == 'true':
                return {"message": "✅ DB already seeded. Skipping."}

            # Check if required tables exist
            tables_to_check = ['users', 'wishlist', 'stocks']
            missing_tables = []

            for table in tables_to_check:
                cur.execute(f"SELECT to_regclass('public.{table}');")
                result = cur.fetchone()[0]
                if result is None:
                    missing_tables.append(table)

            if not missing_tables:
                # All tables exist, just set the marker
                cur.execute("INSERT INTO seed_metadata (key, value) VALUES ('db_seeded', 'true') ON CONFLICT (key) DO NOTHING;")
                conn.commit()
                return {"message": "✅ Tables already exist. Skipped seeding, marker set."}

            # Seed the DB
            with open('/var/task/wishlist.sql', 'r') as f:
                sql = f.read()
                cur.execute(sql)
                conn.commit()

            # Mark seeding complete
            cur.execute("INSERT INTO seed_metadata (key, value) VALUES ('db_seeded', 'true');")
            conn.commit()

        # Delete Lambda function after successful seeding
        try:
            lambda_client.delete_function(FunctionName=LAMBDA_FUNCTION_NAME)
        except Exception as delete_err:
            return {
                "message": "✅ DB seeded. ⚠️ Failed to delete Lambda.",
                "error": str(delete_err)
            }

        return {"message": "✅ DB seeded and Lambda deleted."}

    except Exception as e:
        return {
            "message": "❌ Seeding failed.",
            "error": str(e),
            "trace": traceback.format_exc()
        }
