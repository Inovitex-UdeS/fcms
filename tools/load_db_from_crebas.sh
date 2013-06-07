#!/bin/bash

export PGPASSWORD="pass"
sudo -u postgres psql -c "DROP DATABASE fcms;"
sudo -u postgres psql -c "CREATE DATABASE fcms;"
sudo -u postgres psql -c "ALTER DATABASE fcms OWNER TO root"
psql -U root -h localhost -w fcms -f ../db/crebas.sql
unset PGPASSWORD