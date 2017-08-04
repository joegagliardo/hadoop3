#! /bin/sh
cp /usr/local/hive/conf/hive-site-mysql.xml /usr/local/hive/conf/hive-site.xml
mysql < /scripts/hiveuser-mysql.sql
schematool -dbType mysql -initSchema
