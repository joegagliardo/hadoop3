#! /bin/sh
# Versions
ARG HADOOP_VERSION=3.0.0
ARG PIG_VERSION=0.17.0
ARG HIVE_VERSION=2.3.3
ARG SPARK_VERSION=2.3.0
ARG ZOOKEEPER_VERSION=3.4.11
ARG HBASE_VERSION=1.4.3
ARG MONGO_VERSION=3.6.3
ARG MONGO_JAVA_DRIVER_VERSION=3.6.3
ARG MONGO_HADOOP_VERSION=2.0.2
ARG CASSANDRA_VERSION=311
ARG SPARK_CASSANDRA_VERSION=2.0.7-s_2.11
ARG COCKROACH_VERSION=2.0.0

# Download URLs
export HADOOP_BASE_URL=http://mirrors.sonic.net/apache/hadoop/common
export HADOOP_URL=${HADOOP_BASE_URL}/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz

export PIG_BASE_URL=http://apache.claz.org/pig
export PIG_URL=${PIG_BASE_URL}/pig-${PIG_VERSION}/pig-${PIG_VERSION}.tar.gz

export HIVE_BASE_URL=http://apache.claz.org/hive
export HIVE_URL=${HIVE_BASE_URL}/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
    
export SPARK_BASE_URL=http://apache.claz.org/spark
export SPARK_URL=${SPARK_BASE_URL}/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz 
    
export ZOOKEEPER_BASE_URL=http://apache.claz.org/zookeeper/
export ZOOKEEPER_URL=${ZOOKEEPER_BASE_URL}/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz

export HBASE_BASE_URL=http://apache.mirrors.pair.com/hbase
export HBASE_URL=${HBASE_BASE_URL}/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz 
    
export MONGO_BASE_URL=https://fastdl.mongodb.org/linux
export MONGO_URL=${MONGO_BASE_URL}/mongodb-linux-x86_64-${MONGO_VERSION}.tgz
    
export MONGO_JAVA_DRIVER_BASE_URL=https://repo1.maven.org/maven2/org/mongodb
export MONGO_JAVA_DRIVER_URL=${MONGO_JAVA_DRIVER_BASE_URL}/mongo-java-driver/${MONGO_JAVA_DRIVER_VERSION}/mongo-java-driver-${MONGO_JAVA_DRIVER_VERSION}.jar

export MONGO_HADOOP_BASE_URL=https://repo1.maven.org/maven2/org/mongodb/mongo-hadoop
export MONGO_HADOOP_CORE_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-core/${MONGO_HADOOP_VERSION}/mongo-hadoop-core-${MONGO_HADOOP_VERSION}.jar
export MONGO_HADOOP_HIVE_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-hive/${MONGO_HADOOP_VERSION}/mongo-hadoop-hive-${MONGO_HADOOP_VERSION}.jar
export MONGO_HADOOP_PIG_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-pig/${MONGO_HADOOP_VERSION}/mongo-hadoop-pig-${MONGO_HADOOP_VERSION}.jar
export MONGO_HADOOP_SPARK_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-spark/${MONGO_HADOOP_VERSION}/mongo-hadoop-spark-${MONGO_HADOOP_VERSION}.jar
export MONGO_HADOOP_STREAMING_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-streaming/${MONGO_HADOOP_VERSION}/mongo-hadoop-streaming-${MONGO_HADOOP_VERSION}.jar

export CASSANDRA_URL=http://www.apache.org/dist/cassandra

export SPARK_CASSANDRA_BASE_URL=http://dl.bintray.com/spark-packages/maven/datastax/spark-cassandra-connector
export SPARK_CASSANDRA_URL=${SPARK_CASSANDRA_BASE_URL}/${SPARK_CASSANDRA_VERSION}/spark-cassandra-connector-${SPARK_CASSANDRA_VERSION}.jar
export SPARK_CASSANDRA_FILE=spark-cassandra-connector-${SPARK_CASSANDRA_VERSION}.jar

export SPARK_HBASE_GIT=https://github.com/hortonworks-spark/shc.git
export SPARK_XML_GIT=https://github.com/databricks/spark-xml.git
export MONGO_REPO_URL=http://repo.mongodb.org/apt/ubuntu 

export COCKROACH_BASE_URL=https://binaries.cockroachdb.com
export COCKROACH_URL=${COCKROACH_BASE_URL}/cockroach-v${COCKROACH_VERSION}.linux-amd64.tgz

url_exists() { echo $1; if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $HADOOP_URL && \
    url_exists $PIG_URL && \
    url_exists $HIVE_URL && \
    url_exists $SPARK_URL && \
    url_exists $ZOOKEEPER_URL && \
    url_exists $HBASE_URL && \
    url_exists $MONGO_URL && \
    url_exists $SPARK_CASSANDRA_URL && \
    url_exists $MONGO_JAVA_DRIVER_URL && \
    url_exists $MONGO_HADOOP_CORE_URL && \
    url_exists $MONGO_HADOOP_PIG_URL && \
    url_exists $MONGO_HADOOP_HIVE_URL && \
    url_exists $MONGO_HADOOP_SPARK_URL && \
    url_exists $MONGO_HADOOP_STREAMING_URL && \
    url_exists $MONGO_JAVA_DRIVER_URL && \
    url_exists $SPARK_CASSANDRA_URL && \
    url_exists $COCKROACH_URL 
