#!/bin/bash

set -eu
set +x

source .env

# Check if required variables are set
: ${PGPASSWORD:?$PGPASSWORD is not set}
: ${DB_HOST:?$DB_HOST is not set}
: ${DB_USER:?$DB_USER is not set}
: ${POSTGRES_USER:?$POSTGRES_USER is not set}


DEFAULT_SCHEMA="public"

# Create role and update password
function create_role() {
  local pg_host="$1"
  local pg_admin_user="$2"
  local pg_connect_db="$3"
  local pg_target_role="$4"
  local pg_target_password="$5"
  echo "Creating role $pg_target_role"
  psql -X -v ON_ERROR_STOP=1 -v VERBOSITY=terse -h "$pg_host" -U "$pg_admin_user" -d "$pg_connect_db" <<-EOSQL
    DO
    \$$
    BEGIN
      CREATE ROLE $pg_target_role WITH LOGIN PASSWORD '$pg_target_password';
      EXCEPTION WHEN DUPLICATE_OBJECT THEN
      RAISE NOTICE 'Role $pg_target_role already exists, updating password ...';
      ALTER ROLE $pg_target_role WITH PASSWORD '$pg_target_password';
    END;
    \$$;
EOSQL
}

# Add regular privileges for application/service
function add_regular_privileges() {
  local pg_host="$1"
  local pg_admin_user="$2"
  local pg_connect_db="$3"
  local pg_target_role="$4"
  local pg_target_db="$5"
  echo "Adding regular privileges for role $pg_target_role to $pg_target_db database"
  psql -X -v ON_ERROR_STOP=1 -v VERBOSITY=terse -h "$pg_host" -U "$pg_admin_user" -d "$pg_connect_db" <<-EOSQL
    DO
    \$$
    BEGIN
      GRANT CONNECT, TEMPORARY ON DATABASE $pg_target_db TO $pg_target_role;
      GRANT USAGE ON SCHEMA public TO $pg_target_role;
      GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO $pg_target_role;
      GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $pg_target_role;
    END;
    \$$;
EOSQL
}

# Add migration privileges (used by Liquibase)
function add_migration_privileges() {
  local pg_host="$1"
  local pg_admin_user="$2"
  local pg_connect_db="$3"
  local pg_target_role="$4"
  local pg_target_db="$5"
  echo "Adding migration privileges for role $pg_target_role to $pg_target_db database"
  psql -X -v ON_ERROR_STOP=1 -v VERBOSITY=terse -h "$pg_host" -U "$pg_admin_user" -d "$pg_connect_db" <<-EOSQL
    DO
    \$$
    BEGIN
      GRANT ALL PRIVILEGES ON DATABASE $pg_target_db TO $pg_target_role;
      GRANT ALL PRIVILEGES ON SCHEMA public TO $pg_target_role;
      GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $pg_target_role;
      GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $pg_target_role;
    END;
    \$$;
EOSQL
}

# Regular user
USER="docker"
PASSWORD="docker"
DB="test"

create_role $DB_HOST $DB_USER $POSTGRES_DB $USER $PASSWORD
add_regular_privileges $DB_HOST $DB_USER $POSTGRES_DB $USER $DB

# Mogration user
USER="migration"
PASSWORD="migration"
DB="test"

create_role $DB_HOST $DB_USER $POSTGRES_DB $USER $PASSWORD
add_regular_privileges $DB_HOST $DB_USER $POSTGRES_DB $USER $DB

echo $?
