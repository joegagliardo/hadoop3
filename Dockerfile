FROM joegagliardo/ubuntu
MAINTAINER joegagliardo

# As much as possible I am trying to put as many steps in a single RUN command to minimize
# the ultimate build size. I also prefer to echo a file and build it in a RUN so there is
# no reliance on outside files needed if you use an ADD

# This section is an easy place to change the desired password and versions to install

EXPOSE 50020 50090 50070 50010 50075 8031 8032 8033 8040 8042 49707 22 8088 8030 3306 10000 10001 10002

# MYSQL Passwords
ARG HIVEUSER_PASSWORD=hivepassword
ARG HIVE_METASTORE=hivemetastore

ADD examples /examples 
ADD datasets /examples
ADD conf /conf
ADD scripts /scripts

# Versions
ARG HADOOP_VERSION=2.8.0
ARG HADOOP_BASE_URL=http://mirrors.sonic.net/apache/hadoop/common
ARG HADOOP_URL=${HADOOP_BASE_URL}/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz

ARG PIG_VERSION=0.16.0
ARG PIG_BASE_URL=http://apache.claz.org/pig
ARG PIG_URL=${PIG_BASE_URL}/pig-${PIG_VERSION}/pig-${PIG_VERSION}.tar.gz

ARG HIVE_VERSION=2.1.1
ARG HIVE_BASE_URL=http://apache.claz.org/hive
ARG HIVE_URL=${HIVE_BASE_URL}/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
    
ARG SPARK_VERSION=2.1.1
#ARG SPARK_BASE_URL=http://apache.claz.org/spark
ARG SPARK_BASE_URL=https://d3kbcqa49mib13.cloudfront.net
ARG SPARK_URL=${SPARK_BASE_URL}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz 
    
ARG ZOOKEEPER_VERSION=3.4.10
ARG ZOOKEEPER_BASE_URL=http://apache.mirrors.lucidnetworks.net/zookeeper/stable
ARG ZOOKEEPER_URL=${ZOOKEEPER_BASE_URL}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz

ARG HBASE_VERSION=1.3.1
ARG HBASE_BASE_URL=http://apache.mirrors.pair.com/hbase
ARG HBASE_URL=${HBASE_BASE_URL}/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz 
    
ARG MONGO_VERSION=3.4.4
ARG MONGO_BASE_URL=https://fastdl.mongodb.org/linux
ARG MONGO_URL=${MONGO_BASE_URL}/mongodb-linux-x86_64-${MONGO_VERSION}.tgz
    
ARG MONGO_HADOOP_VERSION=2.0.2
#ARG MONGO_HADOOP_BASE_URL=http://search.maven.org/remotecontent?filepath=org/mongodb
ARG MONGO_HADOOP_BASE_URL=https://repo1.maven.org/maven2/org/mongodb/mongo-java-driver/3.4.2/mongo-java-driver-3.4.2.jar
ARG MONGO_HADOOP_CORE_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop/mongo-hadoop-core/${MONGO_HADOOP_VERSION}/mongo-hadoop-core-${MONGO_HADOOP_VERSION}.jar

ARG COCKROACH_VERSION=1.0.3
ARG COCKROACH_BASE_URL=https://binaries.cockroachdb.com
ARG COCKROACH_URL=${COCKROACH_BASE_URL}/cockroach-v${COCKROACH_VERSION}.linux-amd64.tgz

#RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
#    url_exists $MONGO_HADOOP_CORE_URL
ARG MONGO_HADOOP_PIG_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop/mongo-hadoop-pig/${MONGO_HADOOP_VERSION}/mongo-hadoop-pig-${MONGO_HADOOP_VERSION}.jar
#RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
#    url_exists $MONGO_HADOOP_PIG_URL
ARG MONGO_HADOOP_HIVE_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop/mongo-hadoop-hive/${MONGO_HADOOP_VERSION}/mongo-hadoop-hive-${MONGO_HADOOP_VERSION}.jar
#RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
#    url_exists $MONGO_HADOOP_HIVE_URL
ARG MONGO_HADOOP_SPARK_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop/mongo-hadoop-spark/${MONGO_HADOOP_VERSION}/mongo-hadoop-spark-${MONGO_HADOOP_VERSION}.jar
#RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
#    url_exists $MONGO_HADOOP_SPARK_URL
ARG MONGO_HADOOP_STREAMING_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop/mongo-hadoop-streaming/${MONGO_HADOOP_VERSION}/mongo-hadoop-streaming-${MONGO_HADOOP_VERSION}.jar
#RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
#    url_exists $MONGO_HADOOP_STREAMING_URL

ARG MONGO_JAVA_DRIVER_VERSION=3.4.2
ARG MONGO_JAVA_DRIVER_URL=${MONGO_HADOOP_BASE_URL}/mongo-java-driver/${MONGO_JAVA_DRIVER_VERSION}/mongo-java-driver-${MONGO_JAVA_DRIVER_VERSION}.jar
#RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
#    url_exists $MONGO_JAVA_DRIVER_URL

ARG CASSANDRA_VERSION=310
ARG CASSANDRA_URL=http://www.apache.org/dist/cassandra

#ARG SPARK_CASSANDRA_VERSION=2.0.1
#ARG SPARK_CASSANRDRA_URL=https://github.com/datastax/spark-cassandra-connector.git
#RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
#    url_exists $SPARK_CASSANDRA_URL
    
ARG SPARK_CASSANDRA_VERSION=2.0.1-s_2.11
ARG SPARK_CASSANDRA_BASE_URL=http://dl.bintray.com/spark-packages/maven/datastax/spark-cassandra-connector
ARG SPARK_CASSANDRA_URL=${SPARK_CASSANDRA_BASE_URL}/${SPARK_CASSANDRA_VERSION}/spark-cassandra-connector-${SPARK_CASSANDRA_VERSION}.jar
ARG SPARK_CASSANDRA_FILE=spark-cassandra-connector-${SPARK_CASSANDRA_VERSION}.jar

ARG SPARK_HBASE_GIT=https://github.com/hortonworks-spark/shc.git
ARG SPARK_XML_GIT=https://github.com/databricks/spark-xml.git
ARG MONGO_REPO_URL=http://repo.mongodb.org/apt/ubuntu 

RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $HADOOP_URL && \
    url_exists $PIG_URL && \
    url_exists $HIVE_URL && \
    url_exists $SPARK_URL && \
    url_exists $ZOOKEEPER_URL && \
    url_exists $HBASE_URL && \
    url_exists $MONGO_URL && \
    url_exists $COCKROACH_URL && \
    url_exists $SPARK_CASSANDRA_URL

USER root

ENV BOOTSTRAP /etc/bootstrap.sh
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
#ENV JAVA_HOME /usr
ENV HADOOP_PREFIX /usr/local/hadoop
ENV PIG_HOME /usr/local/pig
ENV HIVE_HOME /usr/local/hive
ENV ZOOKEEPER_HOME /usr/local/zookeeper/
ENV SPARK_HOME /usr/local/spark
ENV SPARK_CLASSPATH '/usr/local/spark/conf/mysql-connector-java.jar'
ENV PYTHONPATH ${SPARK_HOME}/python/:$(echo ${SPARK_HOME}/python/lib/py4j-*-src.zip):${PYTHONPATH}
ENV HBASE_HOME /usr/local/hbase
ENV HBASE_CONF_DIR=$HBASE_HOME/conf
ENV PATH $PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin:$PIG_HOME/bin:$HIVE_HOME/bin:$ZOOKEEPER_HOME:bin:$SPARK_HOME/bin:$HBASE_HOME/bin

RUN echo "# ---------------------------------------------" && \
    echo "# passwordless ssh" && \
    echo "# ---------------------------------------------" && \
    apt-get update && \
    rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key /root/.ssh/id_rsa && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    echo "# ---------------------------------------------" && \
    echo "# Make folders for HDFS data" && \
    echo "# ---------------------------------------------" && \
    mkdir /data/hdfs && \
    mkdir /data/hdfs/name && \
    mkdir /data/hdfs/data && \
    echo "# ---------------------------------------------" && \
    echo "# Hadoop" && \
    echo "# ---------------------------------------------" && \
    echo ${HADOOP_URL} && \
    curl -s ${HADOOP_URL} | tar -xz -C /usr/local/ && \
    cd /usr/local && \
    ln -s /usr/local/hadoop-${HADOOP_VERSION} /usr/local/hadoop && \
    ln -s /usr/local/hadoop-${HADOOP_VERSION} /hadoop && \
    sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && \
    sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && \
	mv /usr/local/hadoop/etc/hadoop /usr/local/hadoop/etc/hadoop_backup && \
	ln -s /conf/hadoop /usr/local/hadoop/etc/hadoop && \
	mv /conf/ssh_config /root/.ssh/config && \
    chmod 600 /root/.ssh/config && \
    chown root:root /root/.ssh/config && \
	mv /conf/bootstrap.sh /etc/bootstrap.sh && \
    chown root:root /etc/bootstrap.sh && \
    chmod 700 /etc/bootstrap.sh && \
    chmod 700 /scripts/start-hadoop.sh && \
    chmod 700 /scripts/stop-hadoop.sh && \
    ls -la /usr/local/hadoop/etc/hadoop/*-env.sh && \
    chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh && \
    ls -la /usr/local/hadoop/etc/hadoop/*-env.sh && \
    echo "# fix the 254 error code" && \
    sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config && \
    echo "UsePAM no" >> /etc/ssh/sshd_config && \
    echo "Port 2122" >> /etc/ssh/sshd_config && \
    service ssh start $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/sbin/start-dfs.sh $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/root && \
    service ssh start $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/sbin/start-dfs.sh $HADOOP_PREFIX/bin/hdfs dfs -put $HADOOP_PREFIX/etc/hadoop/ input && \
    chmod +x /scripts/loglevel-debug.sh && \
    chmod +x /scripts/loglevel-info.sh && \
    chmod +x /scripts/loglevel-warn.sh && \
    chmod +x /scripts/loglevel-error.sh && \
    echo "# ---------------------------------------------" && \
    echo "# Pig " && \
    echo ${PIG_URL} && \
    echo "# ---------------------------------------------" && \
    curl ${PIG_URL} | tar -zx -C /usr/local && \
    ln -s /usr/local/pig-${PIG_VERSION} /usr/local/pig && \
    mv /usr/local/pig/conf /usr/local/pig/conf_backup && \
    ln -s /conf/pig /usr/local/pig/conf && \
    echo "# ---------------------------------------------" && \
    echo "# Hive" && \
    echo ${HIVE_URL} && \
    echo "# ---------------------------------------------" && \
    curl ${HIVE_URL} | tar -zx -C /usr/local && \
    ln -s /usr/local/apache-hive-${HIVE_VERSION}-bin /usr/local/hive && \
    ln -s /usr/share/java/mysql-connector-java.jar /usr/local/hive/lib/mysql-connector-java.jar && \
    mv /usr/local/hive/conf /usr/local/hive/conf_backup && \
    ln -s /conf/hive /usr/local/hive/conf && \
    wget https://jdbc.postgresql.org/download/postgresql-42.1.3.jar && \
    mv postgresql-42.1.3.jar /usr/local/hive/jdbc && \
    cp /usr/local/hive/jdbc/postgresql-42.1.3.jar /usr/local/hive/lib && \
    echo "# ---------------------------------------------" && \
    echo "# Hiveserver2 Python Package" && \
    echo "# ---------------------------------------------" && \
    apt-get -y install libsasl2-dev && \
    pip2 install pyhs2 && \
    pip3 install pyhs2 && \
    echo "# ---------------------------------------------" && \
    echo "# Make scripts executable" && \
    echo "# ---------------------------------------------" && \
    chmod +x /scripts/format-namenode.sh && \
    chmod +x /scripts/exit-safemode.sh && \
    chmod +x /scripts/start-thrift.sh && \
    chmod +x /scripts/init-schema-mysql.sh && \
    chmod +x /scripts/init-schema-postgres.sh && \
    chmod +x /scripts/start-everything.sh && \
    chmod +x /scripts/stop-everything.sh && \
    chmod +x /scripts/start-hiveserver.sh && \
    echo "# ---------------------------------------------" && \
    echo "# Spark" && \
    echo ${SPARK_URL} && \
    echo "# ---------------------------------------------" && \
    curl ${SPARK_URL} | tar -zx -C /usr/local && \
    ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop2.7 /usr/local/spark && \
    ln -s /usr/local/hive/conf/hive-site.xml /usr/local/spark/conf/hive-site.xml && \
    ln -s /usr/share/java/mysql-connector-java.jar /usr/local/spark/conf/mysql-connector-java.jar && \
    mv /usr/local/spark/conf /usr/local/spark/conf_backup && \
    ln -s /conf/spark /usr/local/spark/conf && \
    cd /home && \
    echo "# ---------------------------------------------" && \
    echo "# Spark HBase" && \
    echo ${SPARK_HBASE_GIT} && \
    echo "# ---------------------------------------------" && \
    git clone ${SPARK_HBASE_GIT} && \
    cd shc && \
    mvn package -DskipTests && \
    mvn clean package test && \
    mvn -DwildcardSuites=org.apache.spark.sql.DefaultSourceSuite test && \
    echo "# ---------------------------------------------" && \
    echo "# HBase" && \
    echo ${HBASE_URL} && \
    echo "# ---------------------------------------------" && \
    curl ${HBASE_URL} | tar -zx -C /usr/local && \
    ln -s /usr/local/hbase-${HBASE_VERSION} /usr/local/hbase && \
    mv /usr/local/hbase/conf /usr/local/hbase/conf_backup &&\
    ln -s /conf/hbase /usr/local/hbase/conf && \
    echo "# ---------------------------------------------" && \
    echo "# Zookeeper" && \
    echo ${ZOOKEEPER_URL} && \
    echo "# ---------------------------------------------" && \
    curl ${ZOOKEEPER_URL} | tar -zx -C /usr/local && \
    ln -s /usr/local/zookeeper-${ZOOKEEPER_VERSION} /usr/local/zookeeper && \
    mkdir /usr/local/zookeeper/data && \
    mv /usr/local/zookeeper/conf /usr/local/zookeeper/conf_backup && \
    ln -s /conf/zookeeper /usr/local/zookeeper/conf && \
    pip2 install happybase psycopg2 && \
    pip3 install happybase psycopg2 && \
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
    echo "# Cassandra libraries" && \
    echo "# ---------------------------------------------" && \
    pip2 install cassandra-driver && \
    pip3 install cassandra-driver && \
    echo "# ---------------------------------------------" && \
    echo "# Helper scripts" && \
    echo "# ---------------------------------------------" && \
    chmod +x /scripts/create-datadirs.sh && \
    chmod +x /scripts/delete-datadirs.sh && \
    cd /scripts && \
    echo "# ---------------------------------------------" && \
    echo "# Postgresql" && \
    echo "# ---------------------------------------------" && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install postgresql postgresql-contrib postgresql-client && \
    chmod +x /scripts/start-postgres.sh && \
    chmod +x /scripts/stop-postgres.sh && \
    chmod +x /scripts/postgres-client.sh && \
    echo "# ---------------------------------------------" && \
    echo "# Cockroach DB" && \
    echo "# ---------------------------------------------" && \
    wget ${COCKROACH_URL} && \
    tar xfz cockroach-* && \
    mv cockroach-v${COCKROACH_VERSION}.linux-amd64/cockroach /usr/local/bin && \
    rm -r /scripts/cockroach* && \
    echo "#! /bin/sh" > /scripts/start-cockroach.sh && \
    echo "cd /data" >> /scripts/start-cockroach.sh && \
    echo "cockroach start --insecure --host=localhost &" >> /scripts/start-cockroach.sh && \
    chmod +x /scripts/start-cockroach.sh && \
    echo "#! /bin/sh" > /scripts/cockroach-shell.sh && \
    echo "cd /data" >> /scripts/cockroach-shell.sh && \
    echo "cockroach sql --insecure" >> /scripts/cockroach-shell.sh && \
    chmod +x /scripts/cockroach-shell.sh && \
    echo "# ---------------------------------------------" && \
    echo "# Spark XML library" && \
    echo "# ---------------------------------------------" && \
    cd /home && \
    git clone ${SPARK_XML_GIT} && \
    cd /home/spark-xml && \
    sbt/sbt package && \
    cp /home/spark-xml/target/scala-2.11/*.jar /usr/local/spark/jars && \
    ln -s /usr/local/spark/jars/spark-xml_2.11-0.4.1.jar /usr/local/spark/jars/spark-xml.jar && \
    cd /home && \
    rm -r /home/spark-xml && \
	cd /home && \
	git clone https://github.com/minrk/findspark.git && \
	cd /home/findspark && \
    python2 setup.py install && \
	python3 setup.py install && \
	cd /home && \
	rm -r /home/findspark && \
    cd /home && \
    echo "# ---------------------------------------------" && \
    echo "# Spark Cassandra Connector" && \
    echo ${SPARK_CASSANDRA_URL} && \
    echo "# ---------------------------------------------" && \
	wget ${SPARK_CASSANDRA_URL} && \
    mv /home/${SPARK_CASSANDRA_FILE} /usr/local/spark/jars && \
	ln -s /usr/local/spark/jars/${SPARK_CASSANDRA_FILE} /usr/local/spark/jars/spark-cassandra-connector.jar && \
    echo "# ---------------------------------------------" && \
	echo "MONGO-HADOOP" && \
    echo "# ---------------------------------------------" && \
	cd /home && \
	wget --content-disposition ${MONGO_HADOOP_CORE_URL} && \
	wget --content-disposition ${MONGO_HADOOP_PIG_URL} && \
	wget --content-disposition ${MONGO_HADOOP_HIVE_URL} && \
	wget --content-disposition ${MONGO_HADOOP_SPARK_URL} && \
	wget --content-disposition ${MONGO_HADOOP_STREAMING_URL} && \
	wget --content-disposition ${MONGO_JAVA_DRIVER_URL} && \
	mkdir /usr/local/mongo-hadoop && \
	mv mongo-hadoop-core-${MONGO_HADOOP_VERSION}.jar /usr/local/mongo-hadoop && \
	mv mongo-hadoop-pig-${MONGO_HADOOP_VERSION}.jar /usr/local/mongo-hadoop && \
	mv mongo-hadoop-hive-${MONGO_HADOOP_VERSION}.jar /usr/local/mongo-hadoop && \
	mv mongo-hadoop-spark-${MONGO_HADOOP_VERSION}.jar /usr/local/mongo-hadoop && \
	mv mongo-hadoop-streaming-${MONGO_HADOOP_VERSION}.jar /usr/local/mongo-hadoop && \
	mv mongo-java-driver-${MONGO_JAVA_DRIVER_VERSION}.jar /usr/local/mongo-hadoop && \
	ln -s /usr/local/mongo-hadoop/mongo-hadoop-core-${MONGO_HADOOP_VERSION}.jar /usr/local/mongo-hadoop/mongo-hadoop-core.jar && \
	ln -s /usr/local/mongo-hadoop/mongo-hadoop-pig-${MONGO_HADOOP_VERSION}.jar /usr/local/mongo-hadoop/mongo-hadoop-pig.jar && \
	ln -s /usr/local/mongo-hadoop/mongo-hadoop-hive-${MONGO_HADOOP_VERSION}.jar /usr/local/mongo-hadoop/mongo-hadoop-hive.jar && \
	ln -s /usr/local/mongo-hadoop/mongo-hadoop-spark-${MONGO_HADOOP_VERSION}.jar /usr/local/mongo-hadoop/mongo-hadoop-spark.jar && \
	ln -s /usr/local/mongo-hadoop/mongo-hadoop-streaming-${MONGO_HADOOP_VERSION}.jar /usr/local/mongo-hadoop/mongo-hadoop-streaming.jar && \
	ln -s /usr/local/mongo-hadoop/mongo-java-driver-${MONGO_JAVA_DRIVER_VERSION}.jar /usr/local/mongo-hadoop/mongo-java-driver.jar && \
	cd /usr/local/mongo-hadoop && \
	git clone https://github.com/mongodb/mongo-hadoop.git && \
	cd /usr/local/mongo-hadoop/mongo-hadoop/spark/src/main/python && \
	python setup.py install && \
	python3 setup.py install && \
    echo "# ---------------------------------------------" && \
    echo "# Miscellaneous" && \
    echo "# ---------------------------------------------" && \
    echo "alias hist='f(){ history | grep \"\$1\";  unset -f f; }; f'" >> ~/.bashrc && \
	echo "# Final Cleanup" && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    echo "*************" 

RUN echo "*************" && \
    echo "" >> /scripts/notes.txt

CMD ["/etc/bootstrap.sh", "-d"]
# end of actual build



# hive --service hiveserver2 start 
# hive --service hiveserver2 stop
# sudo service hive-server2 start
# !connect jdbc:hive2://localhost:10000



#<name>hadoop.proxyuser.hive.groups</name>
#<value>*</value>
#</property>
#<property>
#<name>hadoop.proxyuser.hive.hosts</name>
#<value>*</value>
#</property>
#    <property>
#        <name>hive.server2.enable.doAs</name>
#        <value>false</value>
#    </property>

