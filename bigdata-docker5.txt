FROM joegagliardo/bigdata
MAINTAINER joegagliardo

ARG SPARK_CASSANDRA_VERSION=2.0.1-s_2.11
ARG SPARK_CASSANDRA_BASE_URL=http://dl.bintray.com/spark-packages/maven/datastax/spark-cassandra-connector
ARG SPARK_CASSANDRA_URL=${SPARK_CASSANDRA_BASE_URL}/${SPARK_CASSANDRA_VERSION}/spark-cassandra-connector-${SPARK_CASSANDRA_VERSION}.jar
ARG SPARK_CASSANDRA_FILE=spark-cassandra-connector-${SPARK_CASSANDRA_VERSION}.jar
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $SPARK_CASSANDRA_URL

USER root

ENV HADOOP_PREFIX /usr/local/hadoop
ENV BOOTSTRAP /etc/bootstrap.sh

ENV PIG_HOME /usr/local/pig
ENV PATH /usr/local/hadoop/bin:/usr/local/hadoop/sbin:$PATH
ENV PATH /usr/local/pig/bin:$PATH
ENV HIVE_HOME /usr/local/hive
ENV PATH /usr/local/hive/bin:$PATH

ENV SPARK_HOME /usr/local/spark
ENV PATH /usr/local/spark/bin:$PATH
ENV SPARK_CLASSPATH '/usr/local/spark/conf/mysql-connector-java.jar'
ENV PYTHONPATH ${SPARK_HOME}/python/:$(echo ${SPARK_HOME}/python/lib/py4j-*-src.zip):${PYTHONPATH}

ENV HBASE_HOME /usr/local/hbase
ENV HBASE_CONF_DIR=$HBASE_HOME/conf
ENV PATH /usr/local/hbase/bin:$PATH

RUN cd /data && \
    echo ${SPARK_CASSANDRA_URL} && \
	wget ${SPARK_CASSANDRA_URL} && \
    mv /data/${SPARK_CASSANDRA_FILE} /usr/local/spark/jars && \
	ln -s /usr/local/spark/jars/${SPARK_CASSANDRA_FILE} /usr/local/spark/jars/spark-cassandra-connector.jar && \
	echo "****"


