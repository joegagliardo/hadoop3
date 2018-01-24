#! /bin/sh
/scripts/stop-mysql.sh
/scripts/stop-postgresql.sh
stop-hadoop.sh
/scripts/stop-mongo.sh
/scripts/stop-cassandra.sh
stop-hbase.sh
