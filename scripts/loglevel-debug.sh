#! /bin/sh
hadoop daemonlog -setlevel localhost:50075 org.apache.hadoop.hdfs.server.datanode.DataNode DEBUG
sed -i -e '/log4j.logger.org.apache.pig=/ s/=.*/=debug,\ A/' /usr/local/pig/conf/log4j.properties
sed -i -e '/log4j.logger.org.apache.hadoop=/ s/=.*/=debug,\ A/' /usr/local/pig/conf/log4j.properties
sed -i -e '/log4j.rootCategory=/ s/=.*/=debug/' /usr/local/spark/conf/log4j.properties
sed -i -e '/log4j.logger.org.apache.spark.repl.Main=/ s/=.*/=debug/' /usr/local/spark/conf/log4j.properties
