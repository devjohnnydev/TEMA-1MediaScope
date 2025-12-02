#!/bin/bash
set -e

echo "=== Starting Media Scope ==="

echo "Waiting for database..."
python << END
import os
import time
import dj_database_url

database_url = os.getenv('DATABASE_URL')
if database_url:
    print(f"Database URL configured: {database_url[:30]}...")
    import psycopg2
    db_config = dj_database_url.parse(database_url)
    max_retries = 30
    for i in range(max_retries):
        try:
            conn = psycopg2.connect(
                host=db_config['HOST'],
                port=db_config['PORT'],
                user=db_config['USER'],
                password=db_config['PASSWORD'],
                dbname=db_config['NAME'],
                sslmode='require' if 'sslmode' not in database_url else None
            )
            conn.close()
            print("Database connection successful!")
            break
        except Exception as e:
            print(f"Attempt {i+1}/{max_retries}: Waiting for database... ({e})")
            time.sleep(2)
    else:
        print("Warning: Could not connect to database after retries")
else:
    print("No DATABASE_URL configured, using SQLite fallback")
END

echo "Running migrations..."
python manage.py migrate --noinput

echo "Creating cache table..."
python manage.py createcachetable --verbosity 0 || true

echo "Collecting static files..."
python manage.py collectstatic --noinput || true

echo "Starting Gunicorn server on port ${PORT:-5000}..."
exec gunicorn config.wsgi --bind 0.0.0.0:${PORT:-5000} --timeout 120 --workers 2 --log-level info
