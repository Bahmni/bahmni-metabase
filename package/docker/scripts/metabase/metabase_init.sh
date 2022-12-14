#!/bin/bash
MB_HOST=localhost
MB_PORT=3000
echo "Waiting for Metabase to start"
while (! curl -s -m 5 http://${MB_HOST}:${MB_PORT}/api/session/properties -o /dev/null); do sleep 5; done

echo "Metabase initiated successfully."

source /app/scripts/user/create_admin.sh
