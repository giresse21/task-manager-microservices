#!/bin/bash
set -e

# Supprimer server.pid
rm -f /app/tmp/pids/server.pid

# Attendre PostgreSQL
echo "Waiting for PostgreSQL..."
until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -c '\q'; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done

echo "PostgreSQL is up - continuing"

# Créer la base de données
echo "Creating database..."
bundle exec rails db:create 2>/dev/null || echo "Database already exists"

# Lancer les migrations
echo "Running migrations..."
bundle exec rails db:migrate 2>/dev/null || echo "Migrations already run"

# Exécuter la commande
exec "$@"