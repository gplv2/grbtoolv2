#!/bin/bash -xe

DATA=http://grbtiles.byteless.net/up/server/php/files/grb.gz

echo "Fetch GRB data ..."

# Download helper scripts to create a configuration file
cd /usr/local/src/

wget --quiet $DATA

# CREATE EXTENSION postgis;
# CREATE EXTENSION postgis_topology;
# CREATE EXTENSION hstore;
echo "Enable PostGIS on GRB database ..."

su - postgres -c "psql -d grb-api -c 'CREATE EXTENSION postgis;'"
su - postgres -c "psql -d grb-api -c 'CREATE EXTENSION postgis_topology;'"
su - postgres -c "psql -d grb-api -c 'CREATE EXTENSION hstore;'"

# psql --set ON_ERROR_STOP=on dbname < infile

echo "Importing data ..."
su - postgres -c "zcat /usr/local/src/grb.gz | psql --set ON_ERROR_STOP=on grb-api"

echo "Done"

sleep 2

