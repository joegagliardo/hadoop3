#! /bin/bash
# Hadoop 3.1.10
FROM joegagliardo/ubuntu
MAINTAINER joegagliardo

# As much as possible I am trying to put as many steps in a single RUN command to minimize
# the ultimate build size. I also prefer to echo a file and build it in a RUN so there is
# no reliance on outside files needed if you use an ADD

# Ports that are used
# 9042 Cassandra
# 9160 Thrift Cassandra clients
# 50010 Datanode
# 50020 Datanode
# 50070 Namenode
# 50090 Secondary Namenode
# 8030 8031 8032 8033 8088 ResourceManager
# 8040 8041 8042 NodeManager
# 10000 HiveServer2
# 9083 Hive MetaStore
# 60000 60010 HBase Master
# 7077 7078 Spark
# 3306 MySQL

# These are all the ports I need to open to make the docker work with the host computer

EXPOSE 22 50010 50020 50070 50075 50090 8030 8031 8032 8033 8040 8041 8042 8088 9083 10000 10001 10002 9160 9042 3306 49707 60000 60010 7077 7078 9870

# This section is an easy place to change the desired password and versions to install
# MYSQL Passwords
ARG HIVEUSER_PASSWORD=hivepassword
ARG HIVE_METASTORE=hivemetastore

# Versions
ARG HADOOP_VERSION=3.1.1
ARG HIVE_VERSION=3.1.0
ARG PIG_VERSION=0.17.0
ARG SPARK_VERSION=2.3.2
ARG ZOOKEEPER_VERSION=3.4.13
ARG SQOOP_VERSION=1.4.7
ARG FLUME_VERSION=1.8.0
ARG FLINK_VERSION=1.6.1
ARG HBASE_VERSION=2.1.0
ARG SPARK_CASSANDRA_VERSION=2.3.1-s_2.11
ARG MONGO_JAVA_DRIVER_VERSION=3.8.2
ARG MONGO_HADOOP_VERSION=2.0.2
ARG COCKROACH_VERSION=2.0.5
ARG POSTGRES_JDBC_VERSION=42.2.5
ARG CASSANDRA_VERSION=311
ARG HIVE_HCATALOG_HBASE_STORAGE_HANDLER_VERSION=0.13.1

# ARG MONGO_VERSION=3.6.3

# Download URLs
ARG HADOOP_BASE_URL=http://mirrors.sonic.net/apache/hadoop/common
ARG HADOOP_FILE=hadoop-${HADOOP_VERSION}.tar.gz
ARG HADOOP_URL=${HADOOP_BASE_URL}/hadoop-${HADOOP_VERSION}/${HADOOP_FILE}
ARG HADOOP_FOLDER=hadoop-${HADOOP_VERSION}

ARG HIVE_BASE_URL=http://apache.claz.org/hive
ARG HIVE_FILE=apache-hive-${HIVE_VERSION}-bin.tar.gz
ARG HIVE_URL=${HIVE_BASE_URL}/hive-${HIVE_VERSION}/${HIVE_FILE}
ARG HIVE_FOLDER=apache-hive-${HIVE_VERSION}-bin
    
ARG PIG_BASE_URL=http://apache.claz.org/pig
ARG PIG_FILE=pig-${PIG_VERSION}.tar.gz
ARG PIG_URL=${PIG_BASE_URL}/pig-${PIG_VERSION}/${PIG_FILE}
ARG PIG_FOLDER=pig-${PIG_VERSION}

ARG SPARK_BASE_URL=http://apache.claz.org/spark
ARG SPARK_FILE=spark-${SPARK_VERSION}-bin-hadoop2.7.tgz 
ARG SPARK_URL=${SPARK_BASE_URL}/spark-${SPARK_VERSION}/${SPARK_FILE}
ARG SPARK_FOLDER=spark-${SPARK_VERSION}-bin-hadoop2.7
    
ARG ZOOKEEPER_BASE_URL=http://apache.claz.org/zookeeper
ARG ZOOKEEPER_FILE=zookeeper-${ZOOKEEPER_VERSION}.tar.gz
ARG ZOOKEEPER_URL=${ZOOKEEPER_BASE_URL}/zookeeper-${ZOOKEEPER_VERSION}/${ZOOKEEPER_FILE}
ARG ZOOKEEPER_FOLDER=zookeeper-${ZOOKEEPER_VERSION}

ARG SQOOP_BASE_URL=http://apache.claz.org/sqoop/1.4.7
ARG SQOOP_FILE=sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0.tar.gz
ARG SQOOP_URL=${SQOOP_BASE_URL}/${SQOOP_FILE}
ARG SQOOP_FOLDER=sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0

ARG FLUME_BASE_URL=http://apache.claz.org/flume
ARG FLUME_FILE=apache-flume-${FLUME_VERSION}-bin.tar.gz 
ARG FLUME_URL=${FLUME_BASE_URL}/${FLUME_VERSION}/${FLUME_FILE}
ARG FLUME_FOLDER=apache-flume-${FLUME_VERSION}-bin

ARG FLINK_BASE_URL=http://apache.claz.org/flink/flink-${FLINK_VERSION}/
ARG FLINK_FILE=flink-${FLINK_VERSION}-bin-scala_2.11.tgz
ARG FLINK_URL=${FLINK_BASE_URL}/${FLINK_FILE}

ARG OOZIE_VERSION=5.0.0
ARG OOZIE_BASE_URL=http://apache.claz.org/oozie/${OOZIE_VERSION}

ARG HBASE_BASE_URL=http://apache.mirrors.pair.com/hbase
ARG HBASE_FILE=hbase-${HBASE_VERSION}-bin.tar.gz
ARG HBASE_URL=${HBASE_BASE_URL}/${HBASE_VERSION}/${HBASE_FILE} 
ARG HBASE_FOLDER=hbase-${HBASE_VERSION}
    
ARG SPARK_CASSANDRA_BASE_URL=http://dl.bintray.com/spark-packages/maven/datastax/spark-cassandra-connector
ARG SPARK_CASSANDRA_FILE=spark-cassandra-connector-${SPARK_CASSANDRA_VERSION}.jar
ARG SPARK_CASSANDRA_URL=${SPARK_CASSANDRA_BASE_URL}/${SPARK_CASSANDRA_VERSION}/${SPARK_CASSANDRA_FILE}

ARG MONGO_JAVA_DRIVER_BASE_URL=https://repo1.maven.org/maven2/org/mongodb
ARG MONGO_JAVA_DRIVER_FILE=mongo-java-driver-${MONGO_JAVA_DRIVER_VERSION}.jar
ARG MONGO_JAVA_DRIVER_URL=${MONGO_JAVA_DRIVER_BASE_URL}/mongo-java-driver/${MONGO_JAVA_DRIVER_VERSION}/${MONGO_JAVA_DRIVER_FILE}

ARG MONGO_HADOOP_BASE_URL=https://repo1.maven.org/maven2/org/mongodb/mongo-hadoop
ARG MONGO_HADOOP_CORE_FILE=mongo-hadoop-core-${MONGO_HADOOP_VERSION}.jar
ARG MONGO_HADOOP_CORE_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-core/${MONGO_HADOOP_VERSION}/${MONGO_HADOOP_CORE_FILE}
ARG MONGO_HADOOP_PIG_FILE=mongo-hadoop-pig-${MONGO_HADOOP_VERSION}.jar
ARG MONGO_HADOOP_PIG_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-pig/${MONGO_HADOOP_VERSION}/${MONGO_HADOOP_PIG_FILE}
ARG MONGO_HADOOP_HIVE_FILE=mongo-hadoop-hive-${MONGO_HADOOP_VERSION}.jar
ARG MONGO_HADOOP_HIVE_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-hive/${MONGO_HADOOP_VERSION}/${MONGO_HADOOP_HIVE_FILE}
ARG MONGO_HADOOP_SPARK_FILE=mongo-hadoop-spark-${MONGO_HADOOP_VERSION}.jar
ARG MONGO_HADOOP_SPARK_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-spark/${MONGO_HADOOP_VERSION}/${MONGO_HADOOP_SPARK_FILE}
ARG MONGO_HADOOP_STREAMING_FILE=mongo-hadoop-streaming-${MONGO_HADOOP_VERSION}.jar
ARG MONGO_HADOOP_STREAMING_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-streaming/${MONGO_HADOOP_VERSION}/${MONGO_HADOOP_STREAMING_FILE}

ARG COCKROACH_BASE_URL=https://binaries.cockroachdb.com
ARG COCKROACH_FILE=cockroach-v${COCKROACH_VERSION}.linux-amd64.tgz
ARG COCKROACH_URL=${COCKROACH_BASE_URL}/${COCKROACH_FILE}
ARG COCKROACH_FOLDER=cockroach-v${COCKROACH_VERSION}.linux-amd64

ARG POSTGRES_JDBC_BASE_URL=https://jdbc.postgresql.org/download
ARG POSTGRES_JDBC_FILE=postgresql-${POSTGRES_JDBC_VERSION}.jar
ARG POSTGRES_JDBC_URL=${POSTGRES_JDBC_BASE_URL}/${POSTGRES_JDBC_FILE}

ARG HIVE_HCATALOG_HBASE_STORAGE_HANDLER_FILE=hive-hcatalog-hbase-storage-handler-${HIVE_HCATALOG_HBASE_STORAGE_HANDLER_VERSION}.jar
ARG HIVE_HCATALOG_HBASE_STORAGE_HANDLER_URL=http://central.maven.org/maven2/org/apache/hive/hcatalog/hive-hcatalog-hbase-storage-handler/${HIVE_HCATALOG_HBASE_STORAGE_HANDLER_VERSION}/${HIVE_HCATALOG_HBASE_STORAGE_HANDLER_FILE}

# GIT projects
ARG FINDSPARK_GIT=https://github.com/minrk/findspark.git
ARG SPARK_HBASE_GIT=https://github.com/hortonworks-spark/shc.git
ARG SPARK_XML_GIT=https://github.com/databricks/spark-xml.git
ARG MONGO_REPO_URL=http://repo.mongodb.org/apt/ubuntu 

ARG CASSANDRA_URL=http://www.apache.org/dist/cassandra

# Add examples, datasets, scripts and configurations
ADD examples /examples 
ADD datasets /examples
ADD conf /conf
ADD scripts /scripts
ADD built /built
ADD VERSION /conf

# this section will build with local downloaded versions, but it is too big to do on docker.com
# I have to add foo so it doesn't error out when I try to ADD the non-existant folders
#ADD download-versions.sh /
ADD downloads/foo downloads/jars /jars/
ADD downloads/foo downloads/git /git/
ADD downloads/foo downloads/pip /pip/
# it will automatically untar the files when adding them individually like this
ADD downloads/foo downloads/tars/${HADOOP_FILE}* /usr/local/
ADD downloads/foo downloads/tars/${HIVE_FILE}* /usr/local/
ADD downloads/foo downloads/tars/${PIG_FILE}* /usr/local/
ADD downloads/foo downloads/tars/${SPARK_FILE}* /usr/local/
ADD downloads/foo downloads/tars/${ZOOKEEPER_FILE}* /usr/local/
ADD downloads/foo downloads/tars/${SQOOP_FILE}* /usr/local/
ADD downloads/foo downloads/tars/${FLUME_FILE}* /usr/local/
ADD downloads/foo downloads/tars/${FLINK_FILE}* /usr/local/
ADD downloads/foo downloads/tars/${HBASE_FILE}* /usr/local/
ADD downloads/foo downloads/tars/${COCKROACH_FILE}* /usr/local/
    
ARG DEBIAN_FRONTEND=noninteractive
USER root

ENV BOOTSTRAP /etc/bootstrap.sh
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV HADOOP_HOME /usr/local/hadoop
ENV PIG_HOME /usr/local/pig
ENV HIVE_HOME /usr/local/hive
ENV HCAT_HOME /usr/local/hive/hcatalog
ENV ZOOKEEPER_HOME /usr/local/zookeeper/
ENV SPARK_HOME /usr/local/spark
ENV SPARK_CLASSPATH '/usr/local/spark/conf/mysql-connector-java.jar:$HCAT_HOME/share/hcatalog/hcatalog-core*.jar:$HCAT_HOME/share/hcatalog/hcatalog-pig-adapter*.jar:$HIVE_HOME/lib/hive-metastore-*.jar:$HIVE_HOME/lib/libthrift-*.jar:$HIVE_HOME/lib/hive-exec-*.jar:$HIVE_HOME/lib/libfb303-*.jar:$HIVE_HOME/lib/jdo2-api-*-ec.jar:$HIVE_HOME/conf:$HADOOP_HOME/conf:$HIVE_HOME/lib/slf4j-api-*.jar'
ENV PYTHONPATH ${SPARK_HOME}/python/:$(echo ${SPARK_HOME}/python/lib/py4j-*-src.zip):${PYTHONPATH}
ENV PYTHONPATH ${SPARK_HOME}/python:${SPARK_HOME}/python/lib:${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip
ENV HBASE_HOME /usr/local/hbase
ENV HBASE_CONF_DIR=$HBASE_HOME/conf
ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PIG_HOME/bin:$HIVE_HOME/bin:$ZOOKEEPER_HOME:bin:$SPARK_HOME/bin:$HBASE_HOME/bin

######################################################################################
RUN echo "# ---------------------------------------------" && \
    echo "# Make scripts executable" && \
    echo "# ---------------------------------------------" && \
    chmod +x /scripts/*.sh && \
    echo "# ---------------------------------------------" && \
    echo "# download jars" && \
    echo "# this function will download the jar files if they are not there from the ADD command above" && \
    echo "# ---------------------------------------------" && \
	cd /jars && \
	download() { echo $1; test -e $1 && echo "exists" || curl --progress-bar $2 > $1; } && \
	download ${POSTGRES_JDBC_FILE} ${POSTGRES_JDBC_URL} && \
	download ${MONGO_JAVA_DRIVER_FILE} ${MONGO_JAVA_DRIVER_URL} && \
	download ${MONGO_HADOOP_CORE_FILE} ${MONGO_HADOOP_CORE_URL} && \
	download ${MONGO_HADOOP_PIG_FILE} ${MONGO_HADOOP_PIG_URL} && \
	download ${MONGO_HADOOP_HIVE_FILE} ${MONGO_HADOOP_HIVE_URL} && \
	download ${MONGO_HADOOP_SPARK_FILE} ${MONGO_HADOOP_SPARK_URL} && \
	download ${MONGO_HADOOP_STREAMING_FILE} ${MONGO_HADOOP_STREAMING_URL} && \
	download ${HIVE_HCATALOG_HBASE_STORAGE_HANDLER_FILE} ${HIVE_HCATALOG_HBASE_STORAGE_HANDLER_URL} && \
    echo "# ---------------------------------------------" && \
    echo "# download pip" && \
    echo "# this function will download the pip files for python 2 & 3 if they are not there from the ADD command above" && \
    echo "# ---------------------------------------------" && \
	cd /pip && \
	download() { echo $1; test -e $1 && echo "$1 exists" || { mkdir -p $1; cd $1; mkdir -p 2; cd 2; pip2 download $1; cd ..; mkdir -p 3; cd 3; pip3 download $1; cd ../..; } } && \
	download pymongo && \
	download pyhive && \
	download happybase && \ 
	download psycopg2 && \
	download cassandra-driver && \
	cd /home && \
    echo "# ---------------------------------------------" && \
    echo "# passwordless ssh" && \
    echo "# ---------------------------------------------" && \
    chmod 0777 /examples && \
    rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key /root/.ssh/id_rsa && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    cd /scripts && \
    echo "# ---------------------------------------------" && \
    echo "# Make folders for HDFS data" && \
    echo "# ---------------------------------------------" && \
    mkdir /data/hdfs && \
    ls -l /usr/local && \
    cd /usr/local && \
    echo "# ---------------------------------------------" && \
    echo "# make install tar function" && \
    echo "# this function will download the jar files if they are not there from the ADD command above and untar them to /usr/local" && \
    echo "# it will also make the friendly symlink name to /usr/local/XXX and /XXX whether it was downloaded already or not" && \
    echo "# install hadoop $HADOOP_FILE $HADOOP_URL $HADOOP_FOLDER" && \
    echo "# ---------------------------------------------" && \ 
    install() { echo $1 $2 $3 $4; test -e /usr/local/${4} && echo "already downloaded"  || curl --progress-bar ${3} | tar -xz -C /usr/local ; test -e /usr/local/$1 && echo "symlink exists" || ln -s /usr/local/$4 /usr/local/$1; test -e /$1 && echo "symlink exists" || ln -s /usr/local/$4 /$1; }  && \
    echo "# ---------------------------------------------" && \
    echo "# Hadoop" && \
    echo "# ---------------------------------------------" && \
    install "hadoop" $HADOOP_FILE $HADOOP_URL $HADOOP_FOLDER && \
    echo "# ---------------------------------------------" && \
    echo "# make backup of default config file and make symlink to my uploaded premade config files" && \
    echo "# ---------------------------------------------" && \
	mv /usr/local/hadoop/etc/hadoop /usr/local/hadoop/etc/hadoop_backup && \
	mv /etc/my.cnf /etc/my.cnf.bak && \
	ln -s /conf/my.cnf /etc/my.cnf && \
	ln -s /conf/hadoop /usr/local/hadoop/etc/hadoop && \
	ln -s /conf/hadoop /usr/local/hadoop/conf && \
	mv /conf/ssh_config /root/.ssh/config && \
    chmod 600 /root/.ssh/config && \
    chown root:root /root/.ssh/config && \
    ln -s /conf/bootstrap-mysql.sh /etc/bootstrap.sh && \
    chown root:root /etc/bootstrap.sh && \
    chmod 700 /etc/bootstrap.sh && \
    chown root:root /conf/bootstrap-mysql.sh && \
    chmod 700 /conf/bootstrap-mysql.sh && \
    chown root:root /conf/bootstrap-postgres.sh && \
    chmod 700 /conf/bootstrap-postgres.sh && \
    chmod 700 /scripts/start-hadoop.sh && \
    chmod 700 /scripts/stop-hadoop.sh && \
    chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh && \
    chmod +x /scripts/loglevel-debug.sh && \
    chmod +x /scripts/loglevel-info.sh && \
    chmod +x /scripts/loglevel-warn.sh && \
    chmod +x /scripts/loglevel-error.sh && \
    echo "" && \
    echo "# ---------------------------------------------" && \
    echo "# Hive" && \
    echo "# ---------------------------------------------" && \
    install "hive" $HIVE_FILE $HIVE_URL $HIVE_FOLDER && \
    echo "# ---------------------------------------------" && \
    echo "# need the mysql connector in the hive folder in order to make the metastore work right" && \
    echo "# ---------------------------------------------" && \
    ln -s /usr/share/java/mysql-connector-java.jar /usr/local/hive/lib/mysql-connector-java.jar && \
    echo "# ---------------------------------------------" && \
    echo "# need the postgres connector in the hive folder in order to make the metastore work right" && \
    echo "# ---------------------------------------------" && \
    ln -s /jars/postgresql* /usr/local/hive/jdbc &&\
    ln -s /jars/postgresql* /usr/local/hive/lib && \
    echo "# ---------------------------------------------" && \
    echo "# make a friends symlink name for the hive-hcatalog-core.jar" && \
    echo "# ---------------------------------------------" && \
    ln -s /usr/local/hive/hcatalog/share/hcatalog/hive-hcatalog-core-${HIVE_VERSION}.jar /usr/local/hive/hcatalog/share/hcatalog/hive-hcatalog-core.jar && \
    echo "# ---------------------------------------------" && \
    echo "# backup default config and make symlink to my uploaded premade config files" && \
    echo "# ---------------------------------------------" && \
    mv /usr/local/hive/conf /usr/local/hive/conf_backup && \
    ln -s /conf/hive /usr/local/hive/conf && \
    echo "# ---------------------------------------------" && \
    echo "# Pig " && \
    echo "# ---------------------------------------------" && \
    install "pig" $PIG_FILE $PIG_URL $PIG_FOLDER && \
    echo "# ---------------------------------------------" && \
    echo "# backup default config and make symlink to my uploaded premade config files" && \
    echo "# ---------------------------------------------" && \
    mv /usr/local/pig/conf /usr/local/pig/conf_backup && \
    ln -s /conf/pig /usr/local/pig/conf && \
    mkdir /usr/local/hive/hcatalog/lib && \
    echo "# ---------------------------------------------" && \
    echo "# copy lib files needed for pig to use hcatalog" && \
    echo "# ---------------------------------------------" && \
    ln -s /conf/hive-hcatalog-hbase-storage-handler-0.13.1.jar /usr/local/hive/hcatalog/lib && \
    ln -s /conf/slf4j-api-1.6.0.jar /usr/local/hive/lib && \
    echo "# ---------------------------------------------" && \
    echo "# Spark" && \
    echo "# ---------------------------------------------" && \
    install "spark" $SPARK_FILE $SPARK_URL $SPARK_FOLDER && \
    echo "# ---------------------------------------------" && \
    echo "# backup default config and make symlink to my uploaded premade config files" && \
    echo "# ---------------------------------------------" && \
    mv /usr/local/spark/conf /usr/local/spark/conf_backup && \
    ln -s /conf/spark /usr/local/spark/conf && \
    echo "# ---------------------------------------------" && \
    echo "# make symlink so spark can use hcatalog" && \
    echo "# ---------------------------------------------" && \
    ln -s /usr/share/java/mysql-connector-java.jar /usr/local/spark/jars/mysql-connector-java.jar && \
    echo "# ---------------------------------------------" && \
    echo "# Sqoop " && \
    echo "# ---------------------------------------------" && \
    install "sqoop" $SQOOP_FILE $SQOOP_URL $SQOOP_FOLDER && \
    echo "# ---------------------------------------------" && \
    echo "# Flume " && \
    echo "# ---------------------------------------------" && \
    install "flume" $FLUME_FILE $FLUME_URL $FLUME_FOLDER && \
    echo "# ---------------------------------------------" && \
    echo "# Flink " && \
    echo "# ---------------------------------------------" && \
    install "flink" $FLINK_FILE $FLINK_URL $FLINK_FOLDER && \
    echo "# ---------------------------------------------" && \
    echo "# HBase" && \
    echo "# ---------------------------------------------" && \
    install "hbase" $HBASE_FILE $HBASE_URL $HBASE_FOLDER && \
    echo "# ---------------------------------------------" && \
    echo "# backup default config and make symlink to my uploaded premade config files" && \
    echo "# ---------------------------------------------" && \
    mv /usr/local/hbase/conf /usr/local/hbase/conf_backup && \
    ln -s /conf/hbase /usr/local/hbase/conf && \
    ln -s /usr/local/hbase/bin/start-hbase.sh /scripts/starthbase.sh && \
    ln -s /usr/local/hbase/bin/stop-hbase.sh /scripts/stophbase.sh && \
    pip2 install happybase psycopg2 && \
    pip3 install happybase psycopg2 && \
    echo "# ---------------------------------------------" && \
    echo "# Zookeeper" && \
    echo "# ---------------------------------------------" && \
    install "zookeeper" $ZOOKEEPER_FILE $ZOOKEEPER_URL $ZOOKEEPER_FOLDER && \
    mkdir /usr/local/zookeeper/data && \
    echo "# ---------------------------------------------" && \
    echo "# backup default config and make symlink to my uploaded premade config files" && \
    echo "# ---------------------------------------------" && \
    mv /usr/local/zookeeper/conf /usr/local/zookeeper/conf_backup && \
    ln -s /conf/zookeeper /usr/local/zookeeper/conf && \
    echo "# ---------------------------------------------" && \
    echo "# Cockroach DB" && \
    echo "# ---------------------------------------------" && \
    install "cockroach" $COCKROACH_FILE $COCKROACH_URL $COCKROACH_FOLDER && \
    echo "# ---------------------------------------------" && \
    echo "# Mongo & Cassandra Keys" && \
    echo "# ---------------------------------------------" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb [ arch=amd64,arm64 ] ${MONGO_REPO_URL} xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    echo "deb ${CASSANDRA_URL}/debian ${CASSANDRA_VERSION}x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list && \
    curl ${CASSANDRA_URL}/KEYS | sudo apt-key add - && \
    apt-get update && \
    echo "# ---------------------------------------------" && \
    echo "# Mongo" && \
    echo "# ---------------------------------------------" && \
    apt-get -y install mongodb-org && \
    cd /pip && \
    pip2 install pymongo && \
    pip3 install pymongo && \
    mkdir /data/mongo && \
    mkdir /data/mongo/data && \
    chmod +x /scripts/start-mongo.sh && \
    chmod +x /scripts/stop-mongo.sh && \
    echo "# ---------------------------------------------" && \
    echo "# Cassandra" && \
    echo ${CASSANDRA_URL} && \
    echo "# ---------------------------------------------" && \
    apt-get -y install cassandra && \
    chmod +x /scripts/start-cassandra.sh && \
    chmod +x /scripts/stop-cassandra.sh && \
    echo "# change the data and log folder" && \
    mkdir /data/cassandra && \
    mkdir /data/cassandra/data && \
    mkdir /data/cassandra/log && \
    mv /etc/cassandra /etc/cassandra_backup && \
    ln -s /conf/cassandra /etc/cassandra && \
    chmod +x /examples/cassandra/test-cassandra-table.py && \
    echo "# ---------------------------------------------" && \
    echo "# Postgresql" && \
    echo "# ---------------------------------------------" && \
    apt-get -yq install postgresql postgresql-contrib postgresql-client && \
    chmod +x /scripts/start-postgres.sh && \
    chmod +x /scripts/stop-postgres.sh && \
    chmod +x /scripts/postgres-client.sh && \
    /etc/init.d/postgresql start && \
    sudo -u postgres psql -c "create user root with password ''; alter user root with SUPERUSER;" && \
    sudo -u postgres psql -c "create database root;" && \
    echo "# ---------------------------------------------" && \
    echo "# Spark XML library" && \
    echo "# ---------------------------------------------" && \
	mv /built/spark-xml* /usr/local/spark/jars && \
    ln -s /usr/local/spark/jars/spark-xml* /usr/local/spark/jars/spark-xml.jar && \
    echo "# ---------------------------------------------" && \
    echo "# Spark HBase" && \
    echo ${SPARK_HBASE_GIT} && \
    echo "# ---------------------------------------------" && \
    mv /built/shc-core*  /usr/local/spark/jars && \
    ln -s /usr/local/spark/jars/shc* /usr/local/spark/jars/shc.jar && \
    echo "# ---------------------------------------------" && \
    echo "# Cassandra libraries" && \
    echo "# ---------------------------------------------" && \
    pip2 install cassandra-driver && \
    pip3 install cassandra-driver && \
    echo "# ---------------------------------------------" && \
    echo "# Helper scripts" && \
    echo "# ---------------------------------------------" && \
    chmod +x /scripts/create-datadirs.sh && \
    chmod +x /scripts/delete-datadirs.sh && \
    echo "# ---------------------------------------------" && \
    echo "# FindSpark" && \
    echo "# ---------------------------------------------" && \
    cd /tmp && \
	git clone https://github.com/minrk/findspark.git && \
	cd /tmp/findspark && \
    python2 setup.py install && \
	python3 setup.py install && \
    echo "# ---------------------------------------------" && \
    echo "# Miscellaneous" && \
    echo "# ---------------------------------------------" && \
    echo "alias hist='f(){ history | grep \"\$1\";  unset -f f; }; f'" >> ~/.bashrc && \
    echo "alias pyspark0='python -i -c\"exec(\\\"from initSpark import initspark, hdfsPath\nsc, spark, conf = initspark()\nfrom pyspark.sql.types import *\\\")\"'" >> ~/.bashrc && \
    echo "ARG PIG_OPTS=-Dhive.metastore.uris=thrift://bigdata:9083" >> ~/.bashrc && \
    echo "ARG PIG_CLASSPATH=$HCAT_HOME/share/hcatalog/hcatalog-core*.jar:$HCAT_HOME/share/hcatalog/hcatalog-pig-adapter*.jar:$HIVE_HOME/lib/hive-metastore-*.jar:$HIVE_HOME/lib/libthrift-*.jar:$HIVE_HOME/lib/hive-exec-*.jar:$HIVE_HOME/lib/libfb303-*.jar:$HIVE_HOME/lib/jdo2-api-*-ec.jar:$HIVE_HOME/conf:$HADOOP_HOME/conf:$HIVE_HOME/lib/slf4j-api-*.jar" >> ~/.bashrc && \
    echo "ARG HCAT_HOME=/usr/local/hive/hcatalog" >> ~/.bashrc && \
	echo "# Final Cleanup" && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* && \
	cd /home && \
	rm -r /tmp/findspark && \
    echo "*************" && \
    echo "" >> /scripts/notes.txt

CMD ["/etc/bootstrap.sh", "-d"]
    

    
######################################################################################
#RUN echo "# ---------------------------------------------" && \
#    echo "# Spark Cassandra Connector" && \
#    echo ${SPARK_CASSANDRA_URL} && \
#    echo "# ---------------------------------------------" && \
#    cd /jars && \
#    test -e /usr/local/jars/${SPARK_CASSANDRA_FILE} && echo "Spark Cassandra Connector exists" || wget ${SPARK_CASSANDRA_URL} && \
#    ln -s /jars/${SPARK_CASSANDRA_FILE} /usr/local/spark/jars/${SPARK_CASSANDRA_FILE} 

#    echo "# ---------------------------------------------" && \
#    echo "# Hiveserver2 Python Package" && \
#    echo "# ---------------------------------------------" && \
#    DEBIAN_FRONTEND=noninteractive apt-get -y install libsasl2-dev && \
#    pip2 install PyHive && \
#    pip3 install PyHive && \
#RUN echo "# ---------------------------------------------" && \
#    echo "# Mongo & Cassandra Keys" && \
#    echo "# ---------------------------------------------" && \
#    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
#    echo "deb [ arch=amd64,arm64 ] ${MONGO_REPO_URL} xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
#    echo "deb ${CASSANDRA_URL}/debian ${CASSANDRA_VERSION}x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list && \
#    curl ${CASSANDRA_URL}/KEYS | sudo apt-key add - && \
#    apt-get update && \
#    echo "# ---------------------------------------------" && \
#    echo "# Mongo" && \
#    echo "# ---------------------------------------------" && \
#    DEBIAN_FRONTEND=noninteractive apt-get -y install mongodb-org && \
#    cd /pip && \
#    pip2 install pymongo && \
#    pip3 install pymongo && \
#    mkdir /data/mongo && \
#    mkdir /data/mongo/data && \
#    chmod +x /scripts/start-mongo.sh && \
#    chmod +x /scripts/stop-mongo.sh 
#RUN echo "# ---------------------------------------------" && \
#    echo "# Cassandra" && \
#    echo ${CASSANDRA_URL} && \
#    echo "# ---------------------------------------------" && \
#    DEBIAN_FRONTEND=noninteractive apt-get -y install cassandra && \
#    chmod +x /scripts/start-cassandra.sh && \
#    chmod +x /scripts/stop-cassandra.sh && \
#    echo "# change the data and log folder" && \
#    mkdir /data/cassandra && \
#    mkdir /data/cassandra/data && \
#   mkdir /data/cassandra/log && \
#    mv /etc/cassandra /etc/cassandra_backup && \
#    ln -s /conf/cassandra /etc/cassandra && \
#    chmod +x /examples/cassandra/test-cassandra-table.py 

    
#ADD downloads/postgresql-42.1.3.jar 
#    mv postgresql-42.1.3.jar /usr/local/hive/jdbc && \
#    cp /usr/local/hive/jdbc/postgresql-42.1.3.jar /usr/local/hive/lib && \

#RUN echo "# ---------------------------------------------" && \
#    echo "# Spark XML library" && \
#    echo "# ---------------------------------------------" && \
#    if [test -e /jars/spark-xml_2.11-0.4.1.jar]; then && \
#       mv /jars/spark-xml_2.11-0.4.1.jar /usr/local/spark/jars && \
#    else && \
#       cd /tmp && \
#       git clone ${SPARK_XML_GIT} && \
#       cd /tmp/spark-xml && \
#       sbt/sbt package && \
#       mv /tmp/spark-xml/target/scala-2.11/*.jar /usr/local/spark/jars && \
#       cd /tmp && \
#       rm -r /tmp/spark-xml
#    fi && \
#    ln -s /usr/local/spark/jars/spark-xml_2.11-0.4.1.jar /usr/local/spark/jars/spark-xml.jar && \
#RUN echo "# ---------------------------------------------" && \
#    echo "# HBase" && \
#    echo ${HBASE_URL} && \
#    echo "# ---------------------------------------------" && \
#    cd /home && \
#    test -e /downloads/hbase.tar.gz && tar -xz -C /downloads/hbase.tar.gz /usr/local/ || curl -s ${HBASE_URL} | tar -xz -C /usr/local/ && \
#    ln -s /usr/local/hbase-${HBASE_VERSION} /usr/local/hbase && \
#    mv /usr/local/hbase/conf /usr/local/hbase/conf_backup &&\
#    ln -s /conf/hbase /usr/local/hbase/conf && \
#    ln -s /usr/local/hbase/bin/start-hbase.sh /scripts/starthbase.sh &&\
#    ln -s /usr/local/hbase/bin/stop-hbase.sh /scripts/stophbase.sh
#RUN echo "# ---------------------------------------------" && \
#    echo "# Zookeeper" && \
#    echo ${ZOOKEEPER_URL} && \
#    echo "# ---------------------------------------------" && \
#    test -e /downloads/zookeeper.tar.gz && tar -xz -C /downloads/zookeeper.tar.gz /usr/local/ || curl -s ${ZOOKEEPER_URL} | tar -xz -C /usr/local/ && \
#    ln -s /usr/local/zookeeper-${ZOOKEEPER_VERSION} /usr/local/zookeeper && \
#    mkdir /usr/local/zookeeper/data && \
#    mv /usr/local/zookeeper/conf /usr/local/zookeeper/conf_backup && \
#    ln -s /conf/zookeeper /usr/local/zookeeper/conf && \
#    pip2 install happybase psycopg2 && \
#    pip3 install happybase psycopg2



#    service ssh start $HADOOP_HOME/etc/hadoop/hadoop-env.sh $HADOOP_HOME/sbin/start-dfs.sh $HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/root && \
#    service ssh start $HADOOP_HOME/etc/hadoop/hadoop-env.sh $HADOOP_HOME/sbin/start-dfs.sh $HADOOP_HOME/bin/hdfs dfs -put $HADOOP_HOME/etc/hadoop/ input && \
#    sed -i '/^ARG JAVA_HOME/ s:.*:ARG JAVA_HOME=/usr\nARG HADOOP_HOME=/usr/local/hadoop\nARG HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
#    sed -i '/^ARG HADOOP_CONF_DIR/ s:.*:ARG HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
#    echo "# fix the 254 error code" && \
#    sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config && \
#    echo "UsePAM no" >> /etc/ssh/sshd_config && \
#    echo "Port 2122" >> /etc/ssh/sshd_config && \
#    service ssh start $HADOOP_HOME/etc/hadoop/hadoop-env.sh $HADOOP_HOME/sbin/start-dfs.sh $HADOOP_HOME/bin/hdfs dfs -mkdir -p /user/root && \
#    service ssh start $HADOOP_HOME/etc/hadoop/hadoop-env.sh $HADOOP_HOME/sbin/start-dfs.sh $HADOOP_HOME/bin/hdfs dfs -put $HADOOP_HOME/etc/hadoop/ input && \
#    echo "# ---------------------------------------------" && \
#    echo "# Make scripts executable" && \
#    echo "# ---------------------------------------------" && \
#    chmod +x /scripts/format-namenode.sh && \
#    chmod +x /scripts/exit-safemode.sh && \
#    chmod +x /scripts/start-thrift.sh && \
#    chmod +x /scripts/init-schema-mysql.sh && \
#    chmod +x /scripts/init-schema-postgres.sh && \
#    chmod +x /scripts/start-everything.sh && \
#    chmod +x /scripts/stop-everything.sh && \


#    test -e /usr/local/hadoop-${HADOOP_VERSION}* && echo "Hadoop Exists" || curl -s ${HADOOP_URL} | tar -xz -C /usr/local/ && \
#     test -e /usr/local/apache-hive-${HIVE_VERSION}-bin && echo "Hive exists" || curl -s ${HIVE_URL} | tar -xz -C /usr/local/ && \
#    test -e /usr/local/pig-${PIG_VERSION}* && echo "Pig exists" || curl -s ${PIG_URL} | tar -xz -C /usr/local/ && \
#    test -e /usr/local/spark-${SPARK_VERSION}* && echo "Spark exists" || curl -s ${SPARK_URL} | tar -xz -C /usr/local/ && \
#

# git clone https://github.com/apache/hbase.git

#	download shc ${SPARK_HBASE_GIT} && \
#	download spark-xml ${SPARK_XML_GIT} && \

#RUN echo "# ---------------------------------------------" && \
#    echo "# Spark HBase" && \
#    echo ${SPARK_HBASE_GIT} && \
#    echo "# ---------------------------------------------" && \
#    cd /tmp && \
#    git clone ${SPARK_HBASE_GIT} && \
#    cd /tmp/shc && \
#    test -e /jars/shc.jar && cp /jars/sjc.jar /usr/local/spark/jars/shc || mvn package -DskipTests && \
#    ln -s /usr/local/spark/jars/shc /usr/local/spark/jars/shc.jar && \
#    cd /tmp && \
#    rm -r /tmp/shc 


#echo "# ---------------------------------------------" && \
#    echo "# Upgrade pip" && \
#    echo "# ---------------------------------------------" && \
#    pip2 install --upgrade pip && \
#    pip3 install --upgrade pip && \

#echo "" 
#RUN && \
#    echo "# ---------------------------------------------" && \
#    echo "# download FindSpark" && \
#    echo "# ---------------------------------------------" && \
#	cd /git && \
#	download() { echo $1; test -e $1 && echo "exists" || git clone $2; } && \
#	download findspark ${FINDSPARK_GIT} && \
#    cd /git/findspark && \
#    python2 setup.py install && \
#	python3 setup.py install && \

    
#    cp /jars/postgresql* /usr/local/hive/hcatalog/share/hcatalog/hive-hcatalog-core-${HIVE_VERSION}.
#    wget https://jdbc.postgresql.org/download/postgresql-42.1.3.jar && \
#    mv postgresql-42.1.3.jar /usr/local/hive/jdbc && \
#    cp /usr/local/hive/jdbc/postgresql-42.1.3.jar /usr/local/hive/lib && \
#    ln -s /usr/local/hive/hcatalog/share/hcatalog/hive-hcatalog-core-${HIVE_VERSION}.jar /usr/local/hive/hcatalog/share/hcatalog/hive-hcatalog-core.jar && \

#     install() { echo $1; test -e /usr/local/$1 && echo "already downloaded" || echo "downloading"; curl --progress-bar $2 | tar -xz -C /usr/local/ ; } && \


#    echo "# ---------------------------------------------" && \
#    echo "# HBase" && \
#    echo ${HBASE_URL} && \
#    echo "# ---------------------------------------------" && \
#    cd /home && \
#    test -e /downloads/hbase.tar.gz && tar -xz -C /downloads/hbase.tar.gz /usr/local/ || curl -s ${HBASE_URL} | tar -xz -C /usr/local/ && \
#    ln -s /usr/local/hbase-${HBASE_VERSION} /usr/local/hbase && \
#    mv /usr/local/hbase/conf /usr/local/hbase/conf_backup &&\
#    ln -s /conf/hbase /usr/local/hbase/conf && \
#    ln -s /usr/local/hbase/bin/start-hbase.sh /scripts/starthbase.sh &&\
#    ln -s /usr/local/hbase/bin/stop-hbase.sh /scripts/stophbase.sh && \
#   echo "# ---------------------------------------------" && \
#    echo "# Zookeeper" && \
#    echo ${ZOOKEEPER_URL} && \
#    echo "# ---------------------------------------------" && \
#    test -e /downloads/zookeeper.tar.gz && tar -xz -C /downloads/zookeeper.tar.gz /usr/local/ || curl -s ${ZOOKEEPER_URL} | tar -xz -C /usr/local/ && \
#    ln -s /usr/local/zookeeper-${ZOOKEEPER_VERSION} /usr/local/zookeeper && \
#    mkdir /usr/local/zookeeper/data && \
#    mv /usr/local/zookeeper/conf /usr/local/zookeeper/conf_backup && \
#    ln -s /conf/zookeeper /usr/local/zookeeper/conf && \
#    pip2 install happybase psycopg2 && \
#    pip3 install happybase psycopg2 && \
#    echo "# ---------------------------------------------" && \
#    echo "# Cockroach DB" && \
#    echo "# ---------------------------------------------" && \
#    install "COCKROACH"
#    ln -s /usr/local/cockroach-v${COCKROACH_VERSION}.linux-amd64/cockroach /usr/local/bin/cockroach && \
    

#export HADOOP_VERSION=3.1.1
#export HADOOP_BASE_URL=http://mirrors.sonic.net/apache/hadoop/common
#export HADOOP_FILE=hadoop-${HADOOP_VERSION}.tar.gz
#export HADOOP_URL=${HADOOP_BASE_URL}/hadoop-${HADOOP_VERSION}/${HADOOP_FILE}
#export HADOOP_FOLDER=hadoop-${HADOOP_VERSION}
#install() { echo $1; eval "filename=$1_FILE"; eval "urlname=$1_URL"; eval "foldername=$1_FOLDER"; echo ${!filename} ${!urlname} ${!foldername}; test -e /usr/local/${!foldername} && echo "already downloaded"  || curl --progress-bar ${!urlname} | tar -xz -C /usr/local ; ln -s /usr/local/${!foldername} /usr/local/${1,,}; } ; install "HADOOP"



#export HADOOP_VERSION=3.1.1
#export HADOOP_BASE_URL=http://mirrors.sonic.net/apache/hadoop/common
#export HADOOP_FILE=hadoop-${HADOOP_VERSION}.tar.gz
#export HADOOP_URL=${HADOOP_BASE_URL}/hadoop-${HADOOP_VERSION}/${HADOOP_FILE}
#export HADOOP_FOLDER=hadoop-${HADOOP_VERSION}
#install() { echo $1; eval "filename=$1_FILE"; eval "urlname=$1_URL"; eval "foldername=$1_FOLDER"; export SYMLINK1="/usr/local/${!foldername}"; export SYMLINK2="/usr/local/${1,,}"; echo ${!filename} ${!urlname} ${!foldername} ${SYMLINK1} ${SYMLINK2} ; test -e /usr/local/${!foldername} && echo "already downloaded"  || curl --progress-bar ${!urlname} | tar -xz -C /usr/local ; test -e ${SYMLINK2} && echo "symlink exists" || ln -s ${SYMLINK1} ${SYMLINK2}; } ; && \
#echo "_______" && \
#install "HADOOP"

#    echo "# ---------------------------------------------" && \ export symlink2='/usr/local/'${1,,}; eval "symlink1=$1_FOLDER" ;   ln -s ${!symlink1} ${!symlink2};


#    untar() { echo "Downloading $1"; curl --progress-bar $1 | tar -xz -C /usr/local ;};  
    
    
#     test -e /usr/local/${!foldername} && echo "already downloaded" || untar ${!urlname}; ln -s /usr/local/${!foldername} /usr/local/${1,,} } ; install "HADOOP" 
#    untar() { echo "Downloading $1"; curl --progress-bar $1 | tar -xz -C /usr/local ;};  install() { echo $1; eval "filename=$1_FILE"; eval "urlname=$1_URL"; eval "foldername=$1_FOLDER"; echo ${!filename} ${!urlname} ${!foldername}; test -e /usr/local/${!foldername} && echo "already downloaded" || untar ${!urlname}; ln -s /usr/local/${!foldername} /usr/local/${1,,} } ; install "HADOOP" 


#export HADOOP_VERSION=3.1.1
#export HADOOP_BASE_URL=http://mirrors.sonic.net/apache/hadoop/common
#export HADOOP_FILE=hadoop-${HADOOP_VERSION}.tar.gz
#export HADOOP_URL=${HADOOP_BASE_URL}/hadoop-${HADOOP_VERSION}/${HADOOP_FILE}
#export HADOOP_FOLDER=hadoop-${HADOOP_VERSION}
#install() { echo $1; eval "filename=$1_FILE"; eval "urlname=$1_URL"; eval "foldername=$1_FOLDER"; export SYMLINK1="/usr/local/${!foldername}"; export SYMLINK2="/usr/local/${1,,}"; echo ${!filename} ${!urlname} ${!foldername} ${SYMLINK1} ${SYMLINK2} ; test -e /usr/local/${!foldername} && echo "already downloaded"  || curl --progress-bar ${!urlname} | tar -xz -C /usr/local ; test -e ${SYMLINK2} && echo "symlink exists" || ln -s ${SYMLINK1} ${SYMLINK2}; } ; install "HADOOP" 

# just won't work during docker build
#    echo "# ---------------------------------------------" && \
#    echo "# make install tar function" && \
#    echo "# ---------------------------------------------" && \ 
#    install() { echo $1; eval "filename=$1_FILE"; eval "urlname=$1_URL"; eval "foldername=$1_FOLDER"; export SYMLINK1="/usr/local/${!foldername}"; export SYMLINK2="/usr/local/${1,,}"; echo ${!filename} ${!urlname} ${!foldername} ${SYMLINK1} ${SYMLINK2} ; test -e /usr/local/${!foldername} && echo "already downloaded"  || curl --progress-bar ${!urlname} | tar -xz -C /usr/local ; test -e ${SYMLINK2} && echo "symlink exists" || ln -s ${SYMLINK1} ${SYMLINK2}; } ; && \
#    ln -s /usr/local/hadoop-${HADOOP_VERSION} /hadoop && \


#    ls -la /usr/local/hadoop/etc/hadoop/*-env.sh && \
#    chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh && \
#    ls -la /usr/local/hadoop/etc/hadoop/*-env.sh && \

#    echo "# ---------------------------------------------" && \
#    echo "# need the postgres connector in the hive folder in order to make the metastore work right" && \
#    echo "# ---------------------------------------------" && \
#    cp /jars/postgresql* /usr/local/hive/jdbc &&\
#    cp /jars/postgresql* /usr/local/hive/lib && \

#    ln -s /usr/local/hive/conf/hive-site.xml /usr/local/spark/conf/hive-site.xml && \
#    ln -s /usr/share/java/mysql-connector-java.jar /usr/local/spark/conf/mysql-connector-java.jar && \
