#! /bin/sh
hadoop daemonlog -setlevel localhost:50075 org.apache.hadoop.hdfs.server.datanode.DataNode WARN
sed -i -e '/log4j.logger.org.apache.pig=/ s/=.*/=warn,\A/' /usr/local/pig/conf/log4j.properties
sed -i -e '/log4j.logger.org.apache.hadoop=/ s/=.*/=warn,\A/' /usr/local/pig/conf/log4j.properties
sed -i -e '/log4j.rootCategory=/ s/=.*/=warn/' /usr/local/spark/conf/log4j.properties
sed -i -e '/log4j.logger.org.apache.spark.repl.Main=/ s/=.*/=warn/' /usr/local/spark/conf/log4j.properties
