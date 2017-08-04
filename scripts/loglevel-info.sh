#! /bin/sh
hadoop daemonlog -setlevel localhost:50075 org.apache.hadoop.hdfs.server.datanode.DataNode INFO
sed -i -e '/log4j.logger.org.apache.pig=/ s/=.*/=info,\ A/' /usr/local/pig/conf/log4j.properties
sed -i -e '/log4j.logger.org.apache.hadoop=/ s/=.*/=info,\ A/' /usr/local/pig/conf/log4j.properties
sed -i -e '/log4j.rootCategory=/ s/=.*/=info/' /usr/local/spark/conf/log4j.properties
sed -i -e '/log4j.logger.org.apache.spark.repl.Main=/ s/=.*/=info/' /usr/local/spark/conf/log4j.properties
