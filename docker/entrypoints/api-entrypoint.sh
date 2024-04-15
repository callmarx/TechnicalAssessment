#!/bin/bash
set -e

echo "bundle install..."
bundle check || bundle install --jobs 4

# # Wait until Postgres is ready before running the next step.
# while ! pg_isready -q -h $DATABASE_HOST -p $DATABASE_PORT -U $DATABASE_USERNAME
# do
#   echo "$(date) - waiting for database to start."
#   sleep 2
# done

# If the database exists, migrate. Otherwise setup (create and migrate)
echo "Running database migrations..."
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:create db:migrate
echo "Finished running database migrations."

# Remove a potentially pre-existing server.pid for Rails.
echo "Deleting server.pid file..."
rm -f /tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
