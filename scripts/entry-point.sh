#!/bin/bash
set -e

. /.env

tries=0
while [ ! -f "$PGDATA/postgresql.conf" ]; do
    sleep 1
    tries=$((tries + 1))
    if [ "$tries" -ge 10 ]; then
        echo "postgresql.conf not found after 10 seconds. Exiting..."
        exit 1
    fi
done


CONF_FILE="$PGDATA/postgresql.conf"


echo "Modifying postgresql.conf..."
echo "logging_collector = on"               >> "$CONF_FILE"
echo "log_connections = $Log_Connections"   >> "$CONF_FILE"
echo "log_disconnections = on"              >> "$CONF_FILE"


echo "Restarting PostgreSQL to apply changes..."
pg_ctl restart -D "$PGDATA" -m fast

echo "PostgreSQL restarted with logging_collector enabled."
