import psycopg2
import os

def handler(event, context):
    conn = psycopg2.connect(
        dbname="stockwishlist",
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        host=os.environ["DB_HOST"]
    )

    with conn.cursor() as cur:
        tables_to_check = ['users', 'wishlist', 'stocks']
        missing_tables = []

        for table in tables_to_check:
            cur.execute(f"SELECT to_regclass('public.{table}');")
            result = cur.fetchone()[0]
            if result is None:
                missing_tables.append(table)

        if not missing_tables:
            return {"message": "✅ All required tables already exist. Skipping seed."}

        with open('/var/task/wishlist.sql', 'r') as f:
            sql = f.read()
            cur.execute(sql)
            conn.commit()

    return {"message": "Database seeded successfully."}
