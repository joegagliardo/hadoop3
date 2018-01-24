#! /bin/sh
stop-hadoop.sh
rm -r /data/hdfs/name
rm -r /data/hdfs/data
hdfs namenode -format
start-hadoop.sh
hadoop fs -mkdir /user
hadoop fs -mkdir /user/root
hadoop fs -mkdir /user/hive
hadoop fs -mkdir /user/hive/warehouse
hadoop fs -mkdir /hbase
hadoop fs -mkdir /tmp
hadoop fs -chmod g+w /user/hive/warehouse
hadoop fs -chmod g+w /tmp
hadoop fs -mkdir /stream
hadoop fs -chmod g+w /stream

#/scripts/init-schema.sh
