#! /bin/sh
hadoop daemonlog -setlevel localhost:50075 org.apache.hadoop.hdfs.server.datanode.DataNode ERROR
sed -i -e '/log4j.logger.org.apache.pig=/ s/=.*/=error,\A/' /usr/local/pig/conf/log4j.properties
sed -i -e '/log4j.logger.org.apache.hadoop=/ s/=.*/=error,\A/' /usr/local/pig/conf/log4j.properties
sed -i -e '/log4j.rootCategory=/ s/=.*/=error/' /usr/local/spark/conf/log4j.properties
sed -i -e '/log4j.logger.org.apache.spark.repl.Main=/ s/=.*/=error/' /usr/local/spark/conf/log4j.properties
