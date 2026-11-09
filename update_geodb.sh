#!/bin/sh

GEODB_DIR="/config/geodb"
GEODB_FILE="$GEODB_DIR/GeoLite2-Country.mmdb"
GEODB_URL="https://github.com/P3TERX/GeoLite.mmdb/releases/latest/download/GeoLite2-Country.mmdb"
INTERVAL_SECONDS=259200 # 3 * 24 * 60 * 60

mkdir -p "$GEODB_DIR"

if [ ! -f "$GEODB_FILE" ]; then
    echo "GeoLite2-Country.mmdb not found, downloading..."
    curl -sSL "$GEODB_URL" -o "$GEODB_FILE"
else
    FILE_MOD_TIME=$(stat -c %Y "$GEODB_FILE")
    CURRENT_TIME=$(date +%s)
    AGE=$((CURRENT_TIME - FILE_MOD_TIME))

    if [ "$AGE" -ge "$INTERVAL_SECONDS" ]; then
        echo "GeoLite2-Country.mmdb downloading new version..."
        curl -sSL "$GEODB_URL" -o "$GEODB_FILE"
    else
        echo "GeoLite2-Country.mmdb skip download."
    fi
fi
