#!/bin/bash
set -e

# Function to verify PostgreSQL connection
postgres_ready() {
  python << END
import sys
import psycopg2
import os

try:
    conn = psycopg2.connect(
        dbname=os.environ.get("DB_NAME", "test_db"),
        user=os.environ.get("DB_USER", "postgres"),
        password=os.environ.get("DB_PASSWORD", "postgres"),
        host=os.environ.get("DB_HOST", "database-1.c14wme22qzjq.ap-south-1.rds.amazonaws.com"),
        port=os.environ.get("DB_PORT", "5432")
    )
except psycopg2.OperationalError:
    sys.exit(1)
sys.exit(0)
END
}

# Wait for PostgreSQL to be ready
until postgres_ready; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done

echo "PostgreSQL is up - continuing"

# Apply database migrations
echo "Applying database migrations..."
python notes_project/manage.py migrate --noinput

# Collect static files
echo "Collecting static files..."
python notes_project/manage.py collectstatic --noinput

# Start Gunicorn
echo "Starting Gunicorn server..."
exec gunicorn --bind 0.0.0.0:9005 \
    --workers 3 \
    --timeout 120 \
    --access-logfile - \
    --error-logfile - \
    --name djpormtest \
    notes_project.wsgi:application