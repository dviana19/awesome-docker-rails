#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
if [ -f /rails/tmp/pids/server.pid ]; then
  rm /rails/tmp/pids/server.pid
fi

rails db:prepare

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
