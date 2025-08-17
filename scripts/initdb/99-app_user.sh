#!/bin/bash
set -e

# Run only if app user/pass are provided
if [ -n "$DB_APP_USER" ] && [ -n "$DB_APP_PASS" ]; then
  echo "Creating application user $DB_APP_USER..."

  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Create restricted app user (if not exists)
    DO \$\$
    BEGIN
      IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$DB_APP_USER') THEN
        CREATE USER $DB_APP_USER WITH PASSWORD '$DB_APP_PASS';
      END IF;
    END
    \$\$;

    -- Grant connection to the app database
    GRANT CONNECT ON DATABASE $POSTGRES_DB TO $DB_APP_USER;

    -- Allow schema usage
    GRANT USAGE ON SCHEMA public TO $DB_APP_USER;

    -- Allow DML on tables
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO $DB_APP_USER;

    -- Ensure future tables also get rights
    ALTER DEFAULT PRIVILEGES IN SCHEMA public
      GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO $DB_APP_USER;

    -- Allow DDL on schema
    GRANT CREATE ON SCHEMA public TO $DB_APP_USER;

    -- Allow ownership of tables it creates
    ALTER DEFAULT PRIVILEGES FOR ROLE $POSTGRES_USER
      IN SCHEMA public GRANT ALL ON TABLES TO $DB_APP_USER;

    -- ✅ Grant sequence privileges (needed for auto-increment IDs)
    GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO $DB_APP_USER;

    -- Ensure future sequences also get rights
    ALTER DEFAULT PRIVILEGES IN SCHEMA public
      GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO $DB_APP_USER;
EOSQL
else
  echo "Skipping app user creation — DB_APP_USER or DB_APP_PASS not set"
fi
