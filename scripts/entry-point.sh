#!/bin/bash
set -e
. /.env

echo "Change the logging options"

# Only update logging if DB is not initialized yet
# This check is what the official image uses
if [ ! -s "$PGDATA/PG_VERSION" ]; then
    echo "▶ Database not initialized. Will update logging config after init."

    # Start init process (but don't exec yet — let it initialize the data dir)
    gosu postgres docker-entrypoint.sh "$@" &

    tries=0
    while [ ! -f "$PGDATA/postgresql.conf" ]; do
        sleep 1
        tries=$((tries + 1))
        if [ "$tries" -ge 10 ]; then
            echo "postgresql.conf not found after 10 seconds. Exiting..."
            exit 1
        fi
    done

    echo "▶ postgresql.conf found. Stopping temporary Postgres..."
    gosu postgres pg_ctl -D "$PGDATA" -m fast stop

    echo "▶ Config file created. Updating logging settings..."

    echo "logging_collector = on"           >> "$PGDATA/postgresql.conf"
    echo "log_connections = $Log_Connections"             >> "$PGDATA/postgresql.conf"
    echo "log_disconnections = on"          >> "$PGDATA/postgresql.conf"

    # Wait for init to finish
    # wait
else
    echo "▶ Database already initialized. Skipping config update."
    exec gosu postgres docker-entrypoint.sh "$@"
fi


echo "▶ Starting postgres server"

exec gosu postgres docker-entrypoint.sh "$@"