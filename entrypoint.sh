#!/bin/bash
set -e

echo "bundle install..."
bundle check || bundle install --jobs 4

echo "Running database migrations..."
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:create db:migrate
echo "Finished running database migrations."
echo "Running Sidekiq..."
bundle exec sidekiq >> ./log/sidekiq.log 2>&1 &
echo "Sidekiq is running in backgorund, for its logging see ./log/sidekiq.log"


# Remove a potentially pre-existing server.pid for Rails.
echo "Deleting server.pid file..."
rm -f /tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
