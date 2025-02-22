#!/bin/bash
set -e

if [ -n "${TYPEBOT_DB_USER:-}" ] && [ -n "${TYPEBOT_DB_PASSWORD:-}" ]; then
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<EOSQL
    CREATE DATABASE typebot;
    CREATE USER ${TYPEBOT_DB_USER} WITH PASSWORD '${TYPEBOT_DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON DATABASE typebot TO ${TYPEBOT_DB_USER};
EOSQL

  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "typebot" <<EOSQL
    ALTER SCHEMA public OWNER TO ${TYPEBOT_DB_USER};
    GRANT USAGE, CREATE ON SCHEMA public TO ${TYPEBOT_DB_USER};
EOSQL

  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "postgres" <<EOSQL
    CREATE USER ${N8N_DB_USER} WITH PASSWORD '${N8N_DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON DATABASE n8n TO ${N8N_DB_USER};
EOSQL

  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "n8n" <<EOSQL
    ALTER SCHEMA public OWNER TO ${N8N_DB_USER};
    GRANT USAGE, CREATE ON SCHEMA public TO ${N8N_DB_USER};
EOSQL
else
  echo "SETUP INFO: No Environment variables given!"
fi
