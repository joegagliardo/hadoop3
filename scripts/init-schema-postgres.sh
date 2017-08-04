#! /bin/sh
cp /usr/local/hive/conf/hive-site-postgres.xml /usr/local/hive/conf/hive-site.xml
sudo -u postgres psql -f /scripts/hiveuser-postgres.sql
schematool -dbType postgres -initSchema
