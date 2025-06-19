import sys
import os
import psycopg2
import boto3
import traceback
import json

sys.path.append('/opt')

lambda_client = boto3.client('lambda')
LAMBDA_FUNCTION_NAME = os.environ.get('AWS_LAMBDA_FUNCTION_NAME')

DB_NAME = os.environ.get("DB_NAME")
DB_USER = os.environ.get("DB_USER")
DB_PASSWORD = os.environ.get("DB_PASSWORD")
DB_HOST = os.environ.get("DB_HOST")

TABLES_TO_CHECK = ['users', 'wishlist', 'stocks']

def handler(event, context):
    action = event.get("action", "verify")  # default to verify if no action provided
    conn = None

    try:
        conn = psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST
        )
        with conn.cursor() as cur:

            if action == "seed":
                # Create seed_metadata table if needed
                cur.execute("""
                    CREATE TABLE IF NOT EXISTS seed_metadata (
                        key TEXT PRIMARY KEY,
                        value TEXT
                    );
                """)
                conn.commit()

                # Check if seeding done
                cur.execute("SELECT value FROM seed_metadata WHERE key = 'db_seeded';")
                result = cur.fetchone()
                if result and result[0] == 'true':
                    return {"message": "✅ DB already seeded. Skipping."}

                # Check required tables
                missing_tables = []
                for table in TABLES_TO_CHECK:
                    cur.execute(f"SELECT to_regclass('public.{table}');")
                    result = cur.fetchone()[0]
                    if result is None:
                        missing_tables.append(table)

                if not missing_tables:
                    # Tables exist, mark seeded
                    cur.execute("INSERT INTO seed_metadata (key, value) VALUES ('db_seeded', 'true') ON CONFLICT (key) DO NOTHING;")
                    conn.commit()
                    return {"message": "✅ Tables already exist. Skipped seeding, marker set."}

                # Seed DB from SQL file
                with open('/var/task/wishlist.sql', 'r') as f:
                    sql = f.read()
                    cur.execute(sql)
                    conn.commit()

                # Mark seeding complete
                cur.execute("INSERT INTO seed_metadata (key, value) VALUES ('db_seeded', 'true');")
                conn.commit()

                return {"message": "✅ DB seeded successfully."}

            elif action == "verify":
                # Verify tables exist
                cur.execute("""
                    SELECT tablename
                    FROM pg_tables
                    WHERE schemaname='public';
                """)
                existing_tables = [row[0] for row in cur.fetchall()]

                # For each table, get 10 random rows if it exists and has data
                sample_data = {}
                for table in TABLES_TO_CHECK:
                    if table in existing_tables:
                        try:
                            cur.execute(f"""
                                SELECT * FROM {table}
                                ORDER BY random()
                                LIMIT 10;
                            """)
                            rows = cur.fetchall()
                            colnames = [desc[0] for desc in cur.description]

                            # Convert rows to list of dicts
                            sample_data[table] = [dict(zip(colnames, row)) for row in rows]
                        except Exception as e:
                            sample_data[table] = f"Error fetching data: {str(e)}"
                    else:
                        sample_data[table] = "Table does not exist"

                return {
                    "message": "✅ Verification complete.",
                    "tables": existing_tables,
                    "sample_data": sample_data
                }

            else:
                return {
                    "message": "❌ Invalid action specified. Use 'seed' or 'verify'."
                }

    except Exception as e:
        return {
            "message": "❌ Operation failed.",
            "error": str(e),
            "trace": traceback.format_exc()
        }

    finally:
        if conn:
            conn.close()
