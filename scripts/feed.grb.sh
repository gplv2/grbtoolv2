#!/bin/bash -xe

DATA=http://grbtiles.byteless.net/up/server/php/files/grb.gz

echo "Fetch GRB data ..."

# Download helper scripts to create a configuration file
cd /usr/local/src/

wget --quiet $DATA
