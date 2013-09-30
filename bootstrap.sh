#!/usr/bin/env bash

useradd osm

apt-get update

# add osmjapan PPA repository
apt-get install -y python-software-properties
apt-add-repository -y ppa:osmjapan/ppa
#apt-add-repository -y ppa:osmjapan/testing
apt-add-repository -y ppa:miurahr/openstreetmap
apt-get update

# install nginx/openresty
apt-get install -y nginx-openresty
#apt-get install -y nginx-extras # > 1.4.1-0ppa1


# install mapnik
apt-get install -y libmapnik-dev
apt-get install -y ttf-unifont ttf-dejavu ttf-dejavu-core ttf-dejavu-extra

# default locale will be taken from user locale so we set locale to UTF8
sudo update-locale LANG=en_US.UTF-8
export LANG=en_US.UTF-8
# install postgis
apt-get install -y postgresql-9.1 postgresql-contrib-9.1 postgresql-9.1-postgis
# install osm2pgsql
apt-get install -y --force-yes -o openstreetmap-postgis-db-setup::initdb=gis -o openstreetmap-postgis-db-setup::dbname=gis -o openstreetmap-postgis-db-setup::grant_user=osm openstreetmap-postgis-db-setup osm2pgsql

# install Tirex
apt-get install -y tirex-core tirex-backend-mapnik tirex-example-map

# install Lua OSM library
apt-get install -y geoip-database lua5.1 lua-bitop
apt-get install -y lua-nginx-osm


# install osmosis
apt-get install -y openjdk-7-jre
cd /tmp
if [ -f osmosis-latest.tgz ]; then
wget http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-latest.tgz
fi
mkdir -p /opt/osmosis
cd /opt/osmosis;tar zxf /tmp/osmosis-latest.tgz
mkdir -p /var/opt/osmosis
chown osm /var/opt/osmosis

# install tileman package
apt-get install -y tileman

# development dependencies
apt-get install -y devscripts debhelper dh-autoreconf build-essential git
apt-get install -y libfreexl-dev libgdal-dev python-gdal gdal-bin
apt-get install -y libxml2-dev python-libxml2 libsvg

# install Redis-server
apt-get install -y redis-server

# setup postgis database
su postgres -c /usr/bin/tileman-create

# default test data is taiwan (about 16MB by .pbf)
echo  COUNTRY=taiwan >> /etc/tileman.conf
(cd /home/osm;su osm -c /usr/bin/tileman-load)