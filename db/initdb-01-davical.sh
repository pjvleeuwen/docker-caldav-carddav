#!/usr/bin/env bash
set -ex

# based on:
# http://wiki.davical.org/index.php/PostgreSQL_Config

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE ROLE davical_app WITH UNENCRYPTED PASSWORD 'davical';
  CREATE ROLE davical_dba WITH UNENCRYPTED PASSWORD 'davical';
  ALTER ROLE davical_app WITH LOGIN;
  ALTER ROLE davical_dba WITH LOGIN;
  CREATE DATABASE davical WITH OWNER davical_dba
EOSQL

DIR=/docker-entrypoint-initdb.d/davical/

psql -v ON_ERROR_STOP=1 --username davical_dba --dbname davical --file "${DIR}awl-tables.sql"
psql -v ON_ERROR_STOP=1 --username davical_dba --dbname davical --file "${DIR}schema-management.sql"
psql -v ON_ERROR_STOP=1 --username davical_dba --dbname davical --file "${DIR}davical.sql"

"${DIR}update-davical-database" --dbhost localhost --dbuser davical_dba --dbpass davical --owner davical_dba --appuser davical_app --nopatch

psql -v ON_ERROR_STOP=1 --username davical_dba --dbname davical --file "${DIR}base-data.sql"
psql -v ON_ERROR_STOP=1 --username davical_dba --dbname davical <<-EOSQL
  GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO davical_app;
  GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO davical_app;
  GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO davical_app;
  UPDATE usr SET password = '**davical' WHERE username = 'admin';
EOSQL

