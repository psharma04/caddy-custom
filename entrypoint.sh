#!/bin/sh

# Run GeoLite2 database update first to ensure file availability before Caddy starts
/usr/local/bin/update_geodb.sh

# Start cron daemon
crond -b -L /var/log/cron.log

# Execute the original Caddy ENTRYPOINT
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
