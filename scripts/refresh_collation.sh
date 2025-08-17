#!/bin/bash
set -e

# Run inside the container with proper env vars already available
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  ALTER DATABASE "$POSTGRES_DB" REFRESH COLLATION VERSION;
  REINDEX DATABASE "$POSTGRES_DB";
EOSQL

