#!/bin/bash

set -eu

# ensure that data directory is owned by 'cloudron' user
chown -R cloudron:cloudron /app/data


echo "Starting Elixir app"

# run the app as user 'cloudron'
cd /app/code
exec /usr/local/bin/gosu cloudron:cloudron mix phx.server
