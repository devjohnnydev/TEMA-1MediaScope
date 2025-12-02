#!/bin/bash
set -e

echo "=== Starting Media Scope ==="
echo "PORT: ${PORT:-5000}"
echo "DEBUG: ${DEBUG:-not set}"

if [ -z "$DATABASE_URL" ]; then
    echo "ERROR: DATABASE_URL is not set!"
    echo "Please configure DATABASE_URL in Railway Variables"
    exit 1
fi

echo "DATABASE_URL configured (first 50 chars): ${DATABASE_URL:0:50}..."

echo "Running migrations..."
python manage.py migrate --noinput || {
    echo "Migration failed! Check DATABASE_URL configuration."
    exit 1
}

echo "Creating cache table..."
python manage.py createcachetable --verbosity 0 || true

echo "Collecting static files..."
python manage.py collectstatic --noinput || true

echo "Starting Gunicorn server on port ${PORT:-5000}..."
exec gunicorn config.wsgi --bind 0.0.0.0:${PORT:-5000} --timeout 120 --workers 2 --log-level info
