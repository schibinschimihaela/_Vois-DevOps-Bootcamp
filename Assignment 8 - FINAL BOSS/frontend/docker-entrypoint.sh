#!/bin/sh
set -e

if [ -n "$API_GATEWAY_URL" ]; then
  echo "Setting API_GATEWAY_URL to: $API_GATEWAY_URL"
  sed -i "s|const API_URL = \".*\";|const API_URL = \"$API_GATEWAY_URL\";|g" /usr/share/nginx/html/src/app.js
else
  echo "WARNING: API_GATEWAY_URL not set, using default"
fi

# Start nginx
exec "$@"