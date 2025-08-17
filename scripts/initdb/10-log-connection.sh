#!/bin/bash
set -e

CONF_FILE="$PGDATA/postgresql.conf"

# Only execute if LOG_CONNECTIONS variable is set and non-empty
if [ -n "$LOG_CONNECTIONS" ]; then
    echo "Modifying postgresql.conf..."
    {
        echo "logging_collector = on"
        echo "log_connections = $LOG_CONNECTIONS"
        echo "log_disconnections = on"
    } >> "$CONF_FILE"
else
    echo "LOG_CONNECTIONS variable not set, skipping modification."
fi
