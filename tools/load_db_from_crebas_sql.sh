#!/bin/bash

# load_db_from_crebas_sql.sh - v1.0
# INOVITEX Team - S6 Genie Info
# Mathieu Paquette <m.paquette@inovitex.com>

export PGPASSWORD="pass"
sudo -u postgres psql -c "DROP DATABASE fcms;"
sudo -u postgres psql -c "CREATE DATABASE fcms;"
sudo -u postgres psql -c "ALTER DATABASE fcms OWNER TO root"
psql -U root -h localhost -w fcms -f ../db/crebas.sql > /dev/null 2>&1
unset PGPASSWORD

echo "crebas.sql loaded successfully"
