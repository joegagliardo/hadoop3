#! /bin/sh
/scripts/start-mysql.sh
/scripts/start-postgres.sh
start-hadoop.sh
/scripts/start-mongo.sh
/scripts/start-cassandra.sh
start-hbase.sh
/scripts/start-hiveserver.sh
/scripts/start-thrift.sh

