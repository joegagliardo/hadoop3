#! /bin/sh
/scripts/start-mysql.sh
/scripts/start-postgres.sh
start-dfs.sh
start-yarn.sh
/scripts/start-mongo.sh
/scripts/start-cassandra.sh
start-hbase.sh
/scripts/start-hiveserver.sh
/scripts/start-thrift.sh

