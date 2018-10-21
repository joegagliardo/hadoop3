#! /bin/bash

# Versions
export HADOOP_VERSION=3.1.1
export HIVE_VERSION=3.1.0
export PIG_VERSION=0.17.0
export SPARK_VERSION=2.3.2
export ZOOKEEPER_VERSION=3.4.13
export SQOOP_VERSION=1.4.7
export FLUME_VERSION=1.8.0

export HBASE_VERSION=2.1.0
#export SPARK_CASSANDRA_VERSION=2.0.7-s_2.11
export SPARK_CASSANDRA_VERSION=2.3.1-s_2.11
export MONGO_JAVA_DRIVER_VERSION=3.8.2
export MONGO_HADOOP_VERSION=2.0.2
export COCKROACH_VERSION=2.0.5
export POSTGRES_JDBC_VERSION=42.2.5
export CASSANDRA_VERSION=311
export HIVE_HCATALOG_HBASE_STORAGE_HANDLER_VERSION=0.13.1

#export MONGO_VERSION=3.6.3

# Download URLs
export HADOOP_BASE_URL=http://mirrors.ibiblio.org/apache/hadoop/common/
export HADOOP_FILE=hadoop-${HADOOP_VERSION}.tar.gz
export HADOOP_URL=${HADOOP_BASE_URL}/hadoop-${HADOOP_VERSION}/${HADOOP_FILE}

export HIVE_BASE_URL=http://apache.claz.org/hive
export HIVE_FILE=apache-hive-${HIVE_VERSION}-bin.tar.gz
export HIVE_URL=${HIVE_BASE_URL}/hive-${HIVE_VERSION}/${HIVE_FILE}
    
export PIG_BASE_URL=http://apache.claz.org/pig
export PIG_FILE=pig-${PIG_VERSION}.tar.gz
export PIG_URL=${PIG_BASE_URL}/pig-${PIG_VERSION}/${PIG_FILE}

export SPARK_BASE_URL=http://apache.claz.org/spark
export SPARK_FILE=spark-${SPARK_VERSION}-bin-hadoop2.7.tgz 
export SPARK_URL=${SPARK_BASE_URL}/spark-${SPARK_VERSION}/${SPARK_FILE}
    
export ZOOKEEPER_BASE_URL=http://apache.claz.org/zookeeper
export ZOOKEEPER_FILE=zookeeper-${ZOOKEEPER_VERSION}.tar.gz
export ZOOKEEPER_URL=${ZOOKEEPER_BASE_URL}/zookeeper-${ZOOKEEPER_VERSION}/${ZOOKEEPER_FILE}

export SQOOP_BASE_URL=http://apache.claz.org/sqoop/1.4.7
export SQOOP_FILE=sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0.tar.gz
export SQOOP_URL=${SQOOP_BASE_URL}/${SQOOP_FILE}

export FLUME_BASE_URL=http://apache.claz.org/flume
export FLUME_FILE=apache-flume-${FLUME_VERSION}-bin.tar.gz 
export FLUME_URL=${FLUME_BASE_URL}/${FLUME_VERSION}/${FLUME_FILE}

export HBASE_BASE_URL=http://apache.mirrors.pair.com/hbase
export HBASE_FILE=hbase-${HBASE_VERSION}-bin.tar.gz
export HBASE_URL=${HBASE_BASE_URL}/${HBASE_VERSION}/${HBASE_FILE} 
    
export SPARK_CASSANDRA_BASE_URL=http://dl.bintray.com/spark-packages/maven/datastax/spark-cassandra-connector
export SPARK_CASSANDRA_FILE=spark-cassandra-connector-${SPARK_CASSANDRA_VERSION}.jar
export SPARK_CASSANDRA_URL=${SPARK_CASSANDRA_BASE_URL}/${SPARK_CASSANDRA_VERSION}/:${SPARK_CASSANDRA_FILE}

export COCKROACH_BASE_URL=https://binaries.cockroachdb.com
export COCKROACH_FILE=cockroach-v${COCKROACH_VERSION}.linux-amd64.tgz
export COCKROACH_URL=${COCKROACH_BASE_URL}/${COCKROACH_FILE}

export POSTGRES_JDBC_BASE_URL=https://jdbc.postgresql.org/download
export POSTGRES_JDBC_FILE=postgresql-${POSTGRES_JDBC_VERSION}.jar
export POSTGRES_JDBC_URL=${POSTGRES_JDBC_BASE_URL}/${POSTGRES_JDBC_FILE}

export MONGO_JAVA_DRIVER_BASE_URL=https://repo1.maven.org/maven2/org/mongodb
export MONGO_JAVA_DRIVER_FILE=mongo-java-driver-${MONGO_JAVA_DRIVER_VERSION}.jar
export MONGO_JAVA_DRIVER_URL=${MONGO_JAVA_DRIVER_BASE_URL}/mongo-java-driver/${MONGO_JAVA_DRIVER_VERSION}/${MONGO_JAVA_DRIVER_FILE}

export MONGO_HADOOP_BASE_URL=https://repo1.maven.org/maven2/org/mongodb/mongo-hadoop
export MONGO_HADOOP_CORE_FILE=mongo-hadoop-core-${MONGO_HADOOP_VERSION}.jar
export MONGO_HADOOP_CORE_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-core/${MONGO_HADOOP_VERSION}/${MONGO_HADOOP_CORE_FILE}
export MONGO_HADOOP_PIG_FILE=mongo-hadoop-pig-${MONGO_HADOOP_VERSION}.jar
export MONGO_HADOOP_PIG_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-pig/${MONGO_HADOOP_VERSION}/${MONGO_HADOOP_PIG_FILE}
export MONGO_HADOOP_HIVE_FILE=mongo-hadoop-hive-${MONGO_HADOOP_VERSION}.jar
export MONGO_HADOOP_HIVE_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-hive/${MONGO_HADOOP_VERSION}/${MONGO_HADOOP_HIVE_FILE}
export MONGO_HADOOP_SPARK_FILE=mongo-hadoop-spark-${MONGO_HADOOP_VERSION}.jar
export MONGO_HADOOP_SPARK_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-spark/${MONGO_HADOOP_VERSION}/${MONGO_HADOOP_SPARK_FILE}
export MONGO_HADOOP_STREAMING_FILE=mongo-hadoop-streaming-${MONGO_HADOOP_VERSION}.jar
export MONGO_HADOOP_STREAMING_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-streaming/${MONGO_HADOOP_VERSION}/${MONGO_HADOOP_STREAMING_FILE}

export HIVE_HCATALOG_HBASE_STORAGE_HANDLER_FILE=hive-hcatalog-hbase-storage-handler-${HIVE_HCATALOG_HBASE_STORAGE_HANDLER_VERSION}.jar
export HIVE_HCATALOG_HBASE_STORAGE_HANDLER_URL=http://central.maven.org/maven2/org/apache/hive/hcatalog/hive-hcatalog-hbase-storage-handler/${HIVE_HCATALOG_HBASE_STORAGE_HANDLER_VERSION}/${HIVE_HCATALOG_HBASE_STORAGE_HANDLER_FILE}

# GIT projects
export FINDSPARK_GIT=https://github.com/minrk/findspark.git
export SPARK_HBASE_GIT=https://github.com/hortonworks-spark/shc.git
export SPARK_XML_GIT=https://github.com/databricks/spark-xml.git
export MONGO_REPO_URL=http://repo.mongodb.org/apt/ubuntu 

export CASSANDRA_URL=http://www.apache.org/dist/cassandra

echo ${SPARK_CASSANDRA_URL}

cd downloads/tars

download() { echo $1; test -e $1 && echo "exists" || curl --progress-bar $2 > $1; } && \
download ${HADOOP_FILE} ${HADOOP_URL} && \
download ${HIVE_FILE} ${HIVE_URL} && \
download ${PIG_FILE} ${PIG_URL} && \
download ${SPARK_FILE} ${SPARK_URL} && \
download ${ZOOKEEPER_FILE} ${ZOOKEEPER_URL} && \
download ${SQOOP_FILE} ${SQOOP_URL} && \
download ${FLUME_FILE} ${FLUME_URL} && \
download ${HBASE_FILE} ${HBASE_URL} && \
download ${COCKROACH_FILE} ${COCKROACH_URL} 

cd ../jars
download() { echo $1; test -e $1 && echo "exists" || curl --progress-bar $2 > $1; } && \
download ${POSTGRES_JDBC_FILE} ${POSTGRES_JDBC_URL} && \
download ${MONGO_JAVA_DRIVER_FILE} ${MONGO_JAVA_DRIVER_URL} && \
download ${MONGO_HADOOP_CORE_FILE} ${MONGO_HADOOP_CORE_URL} && \
download ${MONGO_HADOOP_PIG_FILE} ${MONGO_HADOOP_PIG_URL} && \
download ${MONGO_HADOOP_HIVE_FILE} ${MONGO_HADOOP_HIVE_URL} && \
download ${MONGO_HADOOP_SPARK_FILE} ${MONGO_HADOOP_SPARK_URL} && \
download ${MONGO_HADOOP_STREAMING_FILE} ${MONGO_HADOOP_STREAMING_URL} && \
download ${HIVE_HCATALOG_HBASE_STORAGE_HANDLER_FILE} ${HIVE_HCATALOG_HBASE_STORAGE_HANDLER_URL} 

cd ../git
download() { echo $1; test -e $1 && echo "exists" || git clone $2; } && \
download findspark ${FINDSPARK_GIT} && \
download shc ${SPARK_HBASE_GIT} && \
download spark-xml ${SPARK_XML_GIT}

cd ../pip
download() { echo $1; test -e $1 && echo "exists" || pip2 download $1; pip3 download $1; } && \
download pymongo && \
download pyhive && \
download happybase && \ 
download psycopg2 && \
download cassandra-driver


#download ${SPARK_CASSANDRA_FILE} ${SPARK_CASSANDRA_URL} && \

# echo "Hadoop"
# test -e ${HADOOP_FILE} && echo "exists" || curl --progress-bar ${HADOOP_URL} > ${HADOOP_FILE}
# echo "Pig"
# test -e ${PIG_FILE} && echo "exists" || curl --progress-bar ${PIG_URL} > ${PIG_FILE}
# echo "Hive"
# test -e ${HIVE_FILE} && echo "exists" || curl --progress-bar ${HIVE_URL} > ${HIVE_FILE}
# echo "Spark"
# test -e ${SPARK_FILE} && echo "exists" || curl --progress-bar ${SPARK_URL} > ${SPARK_FILE}
# echo "Zookeeper"
# test -e ${ZOOKEEPER_FILE} && echo "exists" || curl --progress-bar ${ZOOKEEPER_URL} > ${ZOOKEEPER_FILE}
# echo "HBase"
# test -e ${HBASE_FILE} && echo "exists" || curl --progress-bar ${HBASE_URL} > ${HBASE_FILE}
# echo "Spark Cassandra"
# test -e ${SPARK_CASSANDRA_FILE} && echo "exists" || curl --progress-bar ${SPARK_CASSANDRA_URL} > ${SPARK_CASSANDRA_FILE}
# echo "mongo_java_driver"
# test -e ${MONGO_JAVA_DRIVER_FILE} && echo "exists" || curl --progress-bar ${MONGO_JAVA_DRIVER_URL} > ${MONGO_JAVA_DRIVER_FILE}
# echo "mongo_hadoop_core"
# test -e ${MONGO_HADOOP_CORE_FILE} && echo "exists" || curl --progress-bar ${MONGO_HADOOP_CORE_URL} > ${MONGO_HADOOP_CORE_FILE}
# echo "mongo_hadoop_pig"
# test -e ${MONGO_HADOOP_PIG_FILE} && echo "exists" || curl --progress-bar ${MONGO_HADOOP_PIG_URL} > ${MONGO_HADOOP_PIG_FILE}
# echo "mongo_hadoop_hive"
# test -e ${MONGO_HADOOP_HIVE_FILE} && echo "exists" || curl --progress-bar ${MONGO_HADOOP_HIVE_URL} > ${MONGO_HADOOP_HIVE_FILE}
# echo "mongo_hadoop_spark"
# test -e ${MONGO_HADOOP_SPARK_FILE} && echo "exists" || curl --progress-bar ${MONGO_HADOOP_SPARK_URL} > ${MONGO_HADOOP_SPARK_FILE}
# echo "mongo_hadoop_streaming"
# test -e ${MONGO_HADOOP_STREAMING_FILE} && echo "exists" || curl --progress-bar ${MONGO_HADOOP_STREAMING_URL} > ${MONGO_HADOOP_STREAMING_FILE}
# echo "cockroach"
# test -e cockroach.tar.gz && echo "exists" || curl --progress-bar ${COCKROACH_URL} > ${COCKROACH_FILE}
# echo "Postgresql"
# test -e ${POSTGRES_JDBC_FILE} && echo "exists" || curl --progress-bar ${POSTGRES_JDBC_URL} > ${POSTGRES_JDBC_FILE}


#url_exists() { echo $1; if curl --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
#    url_exists $HADOOP_URL && \
#    url_exists $PIG_URL && \
#    url_exists $HIVE_URL && \
#    url_exists $SPARK_URL && \
#    url_exists $ZOOKEEPER_URL && \
#    url_exists $HBASE_URL && \
#    url_exists $SPARK_CASSANDRA_URL && \
#    url_exists $MONGO_JAVA_DRIVER_URL && \
#    url_exists $MONGO_HADOOP_CORE_URL && \
#    url_exists $MONGO_HADOOP_PIG_URL && \
#    url_exists $MONGO_HADOOP_HIVE_URL && \
#    url_exists $MONGO_HADOOP_SPARK_URL && \
#    url_exists $MONGO_HADOOP_STREAMING_URL && \
#    url_exists $MONGO_JAVA_DRIVER_URL && \
#    url_exists $SPARK_CASSANDRA_URL && \
#    url_exists $COCKROACH_URL 

