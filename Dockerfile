FROM joegagliardo/ubuntu
MAINTAINER joegagliardo

# As much as possible I am trying to put as many steps in a single RUN command to minimize
# the ultimate build size. I also prefer to echo a file and build it in a RUN so there is
# no reliance on outside files needed if you use an ADD

# This section is an easy place to change the desired password and versions to install

# MYSQL Passwords
ARG HIVEUSER_PASSWORD=hivepassword

# Versions
ARG HADOOP_VERSION=2.8.0
ARG HADOOP_BASE_URL=http://mirrors.sonic.net/apache/hadoop/common
ARG HADOOP_URL=${HADOOP_BASE_URL}/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $HADOOP_URL

ARG PIG_VERSION=0.16.0
ARG PIG_BASE_URL=http://apache.claz.org/pig
ARG PIG_URL=${PIG_BASE_URL}/pig-${PIG_VERSION}/pig-${PIG_VERSION}.tar.gz
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $PIG_URL

ARG HIVE_VERSION=2.1.1
ARG HIVE_BASE_URL=http://apache.claz.org/hive
ARG HIVE_URL=${HIVE_BASE_URL}/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $HIVE_URL
    
ARG SPARK_VERSION=2.1.1
#ARG SPARK_BASE_URL=http://apache.claz.org/spark
ARG SPARK_BASE_URL=https://d3kbcqa49mib13.cloudfront.net
ARG SPARK_URL=${SPARK_BASE_URL}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz 
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $SPARK_URL
    
ARG HBASE_VERSION=1.3.1
ARG HBASE_BASE_URL=http://apache.mirrors.pair.com/hbase
ARG HBASE_URL=${HBASE_BASE_URL}/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz 
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $HBASE_URL
    
ARG MONGO_VERSION=3.4.4
ARG MONGO_BASE_URL=https://fastdl.mongodb.org/linux
ARG MONGO_URL=${MONGO_BASE_URL}/mongodb-linux-x86_64-${MONGO_VERSION}.tgz
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $MONGO_URL
    
ARG MONGO_HADOOP_VERSION=2.0.2
ARG MONGO_HADOOP_BASE_URL=http://search.maven.org/remotecontent?filepath=org/mongodb/
ARG MONGO_HADOOP_CORE_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-core/${MONGO_HADOOP_VERSION}/mongo-hadoop-core-${MONGO_HADOOP_VERSION}.jar
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $MONGO_HADOOP_CORE_URL
ARG MONGO_HADOOP_PIG_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-pig/${MONGO_HADOOP_VERSION}/mongo-hadoop-pig-${MONGO_HADOOP_VERSION}.jar
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $MONGO_HADOOP_PIG_URL
ARG MONGO_HADOOP_HIVE_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-hive/${MONGO_HADOOP_VERSION}/mongo-hadoop-hive-${MONGO_HADOOP_VERSION}.jar
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $MONGO_HADOOP_HIVE_URL
ARG MONGO_HADOOP_SPARK_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-sparl/${MONGO_HADOOP_VERSION}/mongo-hadoop-spark-${MONGO_HADOOP_VERSION}.jar
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $MONGO_HADOOP_SPARK_URL
ARG MONGO_HADOOP_STREAMING_URL=${MONGO_HADOOP_BASE_URL}/mongo-hadoop-streaming/${MONGO_HADOOP_VERSION}/mongo-hadoop-streaming-${MONGO_HADOOP_VERSION}.jar
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $MONGO_HADOOP_STREAMING_URL

ARG MONGO_JAVA_DRIVER_VERSION=3.4.2
ARG MONGO_JAVA_DRIVER_URL=${MONGO_HADOOP_BASE_URL}/mongo-java-driver/${MONGO_JAVA_DRIVER_VERSION}/mongo-java-driver-${MONGO_JAVA_DRIVER_VERSION}.jar
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $MONGO_JAVA_DRIVER_URL

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
RUN url_exists() { if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then urlexists='YES'; else exit 1; fi } && \
    url_exists $SPARK_CASSANDRA_URL
    
ARG SPARK_HBASE_GIT=https://github.com/hortonworks-spark/shc.git
ARG SPARK_XML_GIT=https://github.com/databricks/spark-xml.git
ARG MONGO_REPO_URL=http://repo.mongodb.org/apt/ubuntu 

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

RUN echo "# passwordless ssh" && \
    rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key /root/.ssh/id_rsa && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
    echo "# Make folders for HDFS data" && \
    mkdir /home/dockerdata/hdfs && \
    echo "# Hadoop" && \
    echo ${HADOOP_URL} && \
    curl -s ${HADOOP_URL} | tar -xz -C /usr/local/ && \
    cd /usr/local && ln -s ./hadoop-${HADOOP_VERSION} hadoop && \
    sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && \
    sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && \
    mkdir $HADOOP_PREFIX/input && \
    cp $HADOOP_PREFIX/etc/hadoop/*.xml $HADOOP_PREFIX/input && \
    echo "# pseudo distributed" && \
    echo "  <configuration>" > $HADOOP_PREFIX/etc/hadoop/core-site.xml.template && \
    echo "      <property>" >> $HADOOP_PREFIX/etc/hadoop/core-site.xml.template && \
    echo "          <name>fs.defaultFS</name>" >> $HADOOP_PREFIX/etc/hadoop/core-site.xml.template && \
    echo "          <value>hdfs://HOSTNAME:9000</value>" >> $HADOOP_PREFIX/etc/hadoop/core-site.xml.template && \
    echo "      </property>" >> $HADOOP_PREFIX/etc/hadoop/core-site.xml.template && \
    echo "  </configuration>" >> $HADOOP_PREFIX/etc/hadoop/core-site.xml.template && \
    sed s/HOSTNAME/localhost/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml && \
    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $HADOOP_PREFIX//etc/hadoop/hdfs-site.xml && \
    echo "<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "<configuration>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "  <property>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "       <name>dfs.replication</name>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "       <value>1</value>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "   </property>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "   <property>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "       <name>dfs.namenode.name.dir</name>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "       <value>file:/home/dockerdata/hdfs/name</value>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "   </property>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "   <property>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "       <name>dfs.datanode.data.dir</name>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "       <value>file:/home/dockerdata/hdfs/data</value>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "   </property>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "</configuration>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "<configuration>" > $HADOOP_PREFIX/etc/hadoop/mapred-site.xml && \
    echo "    <property>" >> $HADOOP_PREFIX/etc/hadoop/mapred-site.xml && \
    echo "        <name>mapreduce.framework.name</name>" >> $HADOOP_PREFIX/etc/hadoop/mapred-site.xml && \
    echo "        <value>yarn</value>" >> $HADOOP_PREFIX/etc/hadoop/mapred-site.xml && \
    echo "    </property>" >> $HADOOP_PREFIX/etc/hadoop/mapred-site.xml && \
    echo "</configuration>" >> $HADOOP_PREFIX/etc/hadoop/mapred-site.xml && \
    echo "<configuration>" > $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "    <property>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "        <name>yarn.nodemanager.aux-services</name>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "        <value>mapreduce_shuffle</value>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "    </property>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "    <property>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      <name>yarn.application.classpath</name>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      <value>/usr/local/hadoop/etc/hadoop, /usr/local/hadoop/share/hadoop/common/*, /usr/local/hadoop/share/hadoop/common/lib/*, /usr/local/hadoop/share/hadoop/hdfs/*, /usr/local/hadoop/share/hadoop/hdfs/lib/*, /usr/local/hadoop/share/hadoop/mapreduce/*, /usr/local/hadoop/share/hadoop/mapreduce/lib/*, /usr/local/hadoop/share/hadoop/yarn/*, /usr/local/hadoop/share/hadoop/yarn/lib/*</value>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "    </property>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "    <property>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "    <description>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      Number of seconds after an application finishes before the nodemanager's" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      DeletionService will delete the application's localized file directory" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      and log directory." >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      To diagnose Yarn application problems, set this property's value large" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      enough (for example, to 600 = 10 minutes) to permit examination of these" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      directories. After changing the property's value, you must restart the" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      nodemanager in order for it to have an effect." >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      The roots of Yarn applications' work directories is configurable with" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      the yarn.nodemanager.local-dirs property (see below), and the roots" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      of the Yarn applications' log directories is configurable with the" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "      yarn.nodemanager.log-dirs property (see also below)." >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "    </description>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "    <name>yarn.nodemanager.delete.debug-delay-sec</name>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "    <value>600</value>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "  </property>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "</configuration>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
    echo "Host *" > /root/.ssh/config && \
    echo "  UserKnownHostsFile /dev/null" >> /root/.ssh/config && \
    echo "  StrictHostKeyChecking no" >> /root/.ssh/config && \
    echo "  LogLevel quiet" >> /root/.ssh/config && \
    echo "  Port 2122" >> /root/.ssh/config && \ 
    chmod 600 /root/.ssh/config && \
    chown root:root /root/.ssh/config && \
    echo '#!/bin/bash' > /etc/bootstrap.sh && \
    echo '' >> /etc/bootstrap.sh && \
    echo ': ${HADOOP_PREFIX:=/usr/local/hadoop}' >> /etc/bootstrap.sh && \
    echo '' >> /etc/bootstrap.sh && \
    echo '$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh' >> /etc/bootstrap.sh && \
    echo '' >> /etc/bootstrap.sh && \
    echo '' >> /etc/bootstrap.sh && \
    echo '# installing libraries if any - (resource urls added comma separated to the ACP system variable)' >> /etc/bootstrap.sh && \
    echo 'cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -' >> /etc/bootstrap.sh && \
    echo '' >> /etc/bootstrap.sh && \
    echo '# altering the core-site configuration' >> /etc/bootstrap.sh && \
    echo 'sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml' >> /etc/bootstrap.sh && \
    echo '' >> /etc/bootstrap.sh && \
    echo 'service ssh start' >> /etc/bootstrap.sh && \
    echo '/etc/init.d/mysql start' >> /etc/bootstrap.sh && \
    echo '$HADOOP_PREFIX/sbin/start-dfs.sh' >> /etc/bootstrap.sh && \
    echo '$HADOOP_PREFIX/sbin/start-yarn.sh' >> /etc/bootstrap.sh && \
    echo '' >> /etc/bootstrap.sh && \
    echo 'if [[ $1 == "-d" ]]; then' >> /etc/bootstrap.sh && \
    echo '  while true; do sleep 1000; done' >> /etc/bootstrap.sh && \
    echo 'fi' >> /etc/bootstrap.sh && \
    echo '' >> /etc/bootstrap.sh && \
    echo 'if [[ $1 == "-bash" ]]; then' >> /etc/bootstrap.sh && \
    echo '  /bin/bash' >> /etc/bootstrap.sh && \
    echo 'fi' >> /etc/bootstrap.sh && \
    chown root:root /etc/bootstrap.sh && \
    chmod 700 /etc/bootstrap.sh && \
    echo "# working around docker.io build error" && \
    ls -la /usr/local/hadoop/etc/hadoop/*-env.sh && \
    chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh && \
    ls -la /usr/local/hadoop/etc/hadoop/*-env.sh && \
    echo "# fix the 254 error code" && \
    sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config && \
    echo "UsePAM no" >> /etc/ssh/sshd_config && \
    echo "Port 2122" >> /etc/ssh/sshd_config && \
    service ssh start $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/sbin/start-dfs.sh $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/root && \
    service ssh start $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh $HADOOP_PREFIX/sbin/start-dfs.sh $HADOOP_PREFIX/bin/hdfs dfs -put $HADOOP_PREFIX/etc/hadoop/ input && \
    echo "# Pig" && \
    echo ${PIG_URL} && \
    curl ${PIG_URL} | tar -zx -C /usr/local && \
    ln -s /usr/local/pig-${PIG_VERSION} /usr/local/pig && \
    echo "# Hive" && \
    echo ${HIVE_URL} && \
    curl ${HIVE_URL} | tar -zx -C /usr/local && \
    ln -s /usr/local/apache-hive-${HIVE_VERSION}-bin /usr/local/hive && \
    ln -s /usr/share/java/mysql-connector-java.jar /usr/local/hive/lib/mysql-connector-java.jar && \
    echo "<configuration>" > /usr/local/hive/conf/hive-site.xml && \
    echo "   <property>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "      <name>javax.jdo.option.ConnectionURL</name>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "      <value>jdbc:mysql://localhost/metastore?useSSL=false</value>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "      <description>metadata is stored in a MySQL server</description>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "   </property>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "   <property>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "      <name>javax.jdo.option.ConnectionDriverName</name>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "      <value>com.mysql.jdbc.Driver</value>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "      <description>MySQL JDBC driver class</description>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "   </property>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "   <property>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "      <name>javax.jdo.option.ConnectionUserName</name>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "      <value>hiveuser</value>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "      <description>user name for connecting to mysql server</description>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "   </property>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "   <property>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "      <name>javax.jdo.option.ConnectionPassword</name>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "      <value>${HIVEUSER_PASSWORD}</value>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "      <description>password for connecting to mysql server</description>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "   </property>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "</configuration>" >> /usr/local/hive/conf/hive-site.xml && \
    echo "# Format Name Node" && \
    cd /home && \
    echo "#! /bin/sh" > /scripts/format-namenode.sh && \
    echo "stop-all.sh" >> /scripts/format-namenode.sh && \
    echo "rm -r/home/dockerdata/hdfs/name" >> /scripts/format-namenode.sh && \
    echo "rm -r/home/dockerdata/hdfs/data" >> /scripts/format-namenode.sh && \
    echo "hdfs namenode -format" >> /scripts/format-namenode.sh && \
    echo "start-all.sh" >> /scripts/format-namenode.sh && \
    echo "hadoop fs -mkdir /user" >> /scripts/format-namenode.sh && \
    echo "hadoop fs -mkdir /user/root" >> /scripts/format-namenode.sh && \
    echo "hadoop fs -mkdir /user/hive" >> /scripts/format-namenode.sh && \
    echo "hadoop fs -mkdir /user/hive/warehouse" >> /scripts/format-namenode.sh && \
    echo "hadoop fs -mkdir /tmp" >> /scripts/format-namenode.sh && \
    echo "hadoop fs -chmod g+w /user/hive/warehouse" >> /scripts/format-namenode.sh && \
    echo "hadoop fs -chmod g+w /tmp" >> /scripts/format-namenode.sh && \
    echo "/scripts/init-schema.sh" >> /scripts/format-namenode.sh && \
    chmod +x /scripts/format-namenode.sh && \
    echo "#! /bin/sh" > /scripts/exit-safemode.sh && \
    echo "hdfs dfsadmin -safemode leave" >> /scripts/exit-safemode.sh && \
    chmod +x /scripts/exit-safemode.sh && \
    echo "#MySQL script to create the Hive metastore and user and then initialize the schema" && \
    echo "create database metastore; CREATE USER 'hiveuser'@'%' IDENTIFIED BY '${HIVEUSER_PASSWORD}'; GRANT all on *.* to 'hiveuser'@localhost identified by '${HIVEUSER_PASSWORD}'; flush privileges;" > /scripts/hiveuser.sql && \
    echo "#! /bin/sh" > /scripts/init-schema.sh && \
    echo "if mysql \"metastore\" >/dev/null 2>&1 </dev/null" >> /scripts/init-schema.sh && \
    echo "then" >> /scripts/init-schema.sh && \
    echo "  mysql -e \"drop database metastore\"" >> /scripts/init-schema.sh && \
    echo "fi" >> /scripts/init-schema.sh && \
    echo "mysql < /scripts/hiveuser.sql" >> /scripts/init-schema.sh && \
    echo "schematool -dbType mysql -initSchema" >> /scripts/init-schema.sh && \
    chmod +x /scripts/init-schema.sh && \
    echo "#! /bin/sh" > /scripts/shutdown-all.sh && \
    echo "stop-yarn.sh" >> /scripts/shutdown-all.sh && \
    echo "stop-dfs.sh" >> /scripts/shutdown-all.sh && \
    echo "/scripts/stop-mongo.sh" >> /scripts/shutdown-all.sh && \
    echo "/scripts/stop-cassandra.sh" >> /scripts/shutdown-all.sh && \
    echo "/scripts/stop-mysql.sh" >> /scripts/shutdown-all.sh && \
    echo "stop-hbase.sh" >> /scripts/shutdown-all.sh && \
    chmod +x /scripts/shutdown-all.sh && \
    echo "# Spark" && \
    echo ${SPARK_URL} && \
    curl ${SPARK_URL} | tar -zx -C /usr/local && \
    ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop2.7 /usr/local/spark && \
    ln -s /usr/local/hive/conf/hive-site.xml /usr/local/spark/conf/hive-site.xml && \
    ln -s /usr/share/java/mysql-connector-java.jar /usr/local/spark/conf/mysql-connector-java.jar && \
    echo "#! /bin/sh" > /scripts/spark-nolog.sh && \
    echo "sed s/log4j.rootCategory=INFO/log4j.rootCategory=ERROR/ /usr/local/spark/conf/log4j.properties.template > /usr/local/spark/conf/log4j.properties" >> /scripts/spark-nolog.sh && \
    chmod +x /scripts/spark-nolog.sh && \
    echo "#! /bin/sh" > /scripts/spark-fulllog.sh && \
    echo "sed s/log4j.rootCategory=INFO/log4j.rootCategory=ERROR/ /usr/local/spark/conf/log4j.properties.template > /usr/local/spark/conf/log4j.properties" >> /scripts/spark-fulllog.sh && \
    chmod +x /scripts/spark-fulllog.sh && \
    cd /home && \
    git clone ${SPARK_HBASE_GIT} && \
    cd shc && \
    mvn package -DskipTests && \
    mvn clean package test && \
    mvn -DwildcardSuites=org.apache.spark.sql.DefaultSourceSuite test && \
    echo "RUN pip2 install happybase" && \
    echo "RUN pip3 install happybase" && \
    echo "# HBase" && \
    echo ${HBASE_URL} && \
    curl ${HBASE_URL} | tar -zx -C /usr/local && \
    ln -s /usr/local/hbase-${HBASE_VERSION} /usr/local/hbase && \
    echo "# configure HBase data directories" && \
    echo "<configuration>" > ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "  <property>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "    <name>hbase.rootdir</name>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "    <value>hdfs://localhost:9000/hbase</value>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "  </property>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "  <property>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "    <name>dfs.replication</name>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "    <value>1</value>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "  </property>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "  <property>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "    <name>hbase.zookeeper.property.dataDir</name>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "    <value>/usr/local/zookeeper</value>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "  </property>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "</configuration>" >> ${HBASE_CONF_DIR}/hbase-site.xml && \
    echo "# Mongo & Cassandra Keys" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb [ arch=amd64,arm64 ] ${MONGO_REPO_URL} xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    echo "deb ${CASSANDRA_URL}/debian ${CASSANDRA_VERSION}x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list && \
    curl ${CASSANDRA_URL}/KEYS | sudo apt-key add - && \
    apt-get update && \
    echo "# Mongo" && \
    apt-get -y install mongodb-org && \
    pip2 install pymongo && \
    pip3 install pymongo && \
    mkdir /home/dockerdata/mongo && \
    mkdir /home/dockerdata/mongo/data && \
    echo "#! /bin/sh" > /scripts/start-mongo.sh && \ 
    echo "mongod --dbpath /home/dockerdata/mongo/data --logpath /home/dockerdata/mongo/log.txt &" >> /scripts/start-mongo.sh && \
    chmod +x /scripts/start-mongo.sh && \
    echo "#! /bin/sh" > /scripts/stop-mongo.sh && \ 
    echo "mongod --shutdown --dbpath /home/dockerdata/mongo/data" >> /scripts/stop-mongo.sh && \ 
    chmod +x /scripts/stop-mongo.sh && \
    echo "# Cassandra" && \
    echo ${CASSANDRA_URL} && \
    apt-get -y install cassandra && \
    echo "#! /bin/sh" > /scripts/start-cassandra.sh && \
    echo "cassandra -p /scripts/cassandra_processid -R" >> /scripts/start-cassandra.sh && \
    chmod +x /scripts/start-cassandra.sh && \
    echo "#! /bin/sh" > /scripts/stop-cassandra.sh && \
    echo "kill -9 \$(cat /scripts/cassandra_processid)" >> /scripts/stop-cassandra.sh && \
    echo "rm scripts/cassandra_processid" >> /scripts/stop-cassandra.sh && \
    chmod +x /scripts/stop-cassandra.sh && \
    echo "# change the data and log folder" && \
    mkdir /home/dockerdata/cassandra && \
    mkdir /home/dockerdata/cassandra/data && \
    mkdir /home/dockerdata/cassandra/log && \
    sed -i 's/    - \/var\/lib\/cassandra\/data/    - \/home\/dockerdata\/cassandra\/data/g' /etc/cassandra/cassandra.yaml && \
    sed -i 's/commitlog_directory: \/var\/lib\/cassandra\/commitlog/commitlog_directory: \/home\/dockerdata\/cassandra\/log/g' /etc/cassandra/cassandra.yaml && \
    echo "create keyspace joey with replication = {'class':'SimpleStrategy', 'replication_factor': 3};" > /scripts/create-cassandra-table.cql && \
    echo "use joey;" >> /scripts/create-cassandra-table.cql && \
    echo "create table names (id int PRIMARY KEY, name varchar);" >> /scripts/create-cassandra-table.cql && \
    echo "insert into names (id, name) values (1, 'joey');" >> /scripts/create-cassandra-table.cql && \
    echo "#! /usr/bin/python" > /scripts/test-cassandra-table.py && \
    echo "from cassandra.cluster import Cluster" >> /scripts/test-cassandra-table.py && \
    echo "cluster = Cluster()" >> /scripts/test-cassandra-table.py && \
    echo "session = cluster.connect('joey')" >> /scripts/test-cassandra-table.py && \
    echo "rows = session.execute('SELECT id, name FROM names')" >> /scripts/test-cassandra-table.py && \
    echo "print list(rows)" >> /scripts/test-cassandra-table.py && \
    chmod +x /scripts/test-cassandra-table.py && \
    pip2 install cassandra-driver && \
    pip3 install cassandra-driver && \
    echo "#! /bin/sh" > /scripts/create-datadirs.sh && \
    echo "mkdir /home/dockerdata/mysql" >> /scripts/create-datadirs.sh && \
    echo "mkdir /home/dockerdata/mongo " >> /scripts/create-datadirs.sh && \
    echo "mkdir /home/dockerdata/mongo/data" >> /scripts/create-datadirs.sh && \
    echo "mkdir /home/dockerdata/cassandra" >> /scripts/create-datadirs.sh && \
    echo "mkdir /home/dockerdata/cassandra/data" >> /scripts/create-datadirs.sh && \
    echo "mkdir /home/dockerdata/cassandra/log" >> /scripts/create-datadirs.sh && \
    chmod +x /scripts/create-datadirs.sh && \
    echo "#! /bin/sh" > /scripts/delete-datadirs.sh && \
    echo "rm -r /home/dockerdata/mysql" >> /scripts/delete-datadirs.sh && \
    echo "rm -r /home/dockerdata/mongo " >> /scripts/delete-datadirs.sh && \
    echo "rm -r /home/dockerdata/cassandra" >> /scripts/delete-datadirs.sh && \
    chmod +x /scripts/delete-datadirs.sh && \
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
    echo ${SPARK_CASSANDRA_URL} && \
	wget ${SPARK_CASSANDRA_URL} && \
    mv /home/${SPARK_CASSANDRA_FILE} /usr/local/spark/jars && \
	ln -s /usr/local/spark/jars/${SPARK_CASSANDRA_FILE} /usr/local/spark/jars/spark-cassandra-connector.jar && \
	echo "MONGO-HADOOP" && \
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
	git clone https://github.com/mongodb/mongo-hadoop.git && \
	cd /usr/local/mongo-hadoop/mongo-hadoop/spark/src/main/python && \
	python setup.py install && \
	python3 setup.py install && \
	echo "# Final Cleanup" && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    echo "*************" 




RUN echo "*************" && \
    echo "" >> /scripts/notes.txt

#	cd /data && \
#   echo ${SPARK_CASSANDRA_URL} && \
#	wget ${SPARK_CASSANDRA_URL} && \
#   mv /data/${SPARK_CASSANDRA_FILE} /usr/local/spark/jars && \
#	ln -s /usr/local/spark/jars/${SPARK_CASSANDRA_FILE} /usr/local/spark/jars/spark-cassandra-connector.jar && \

# wget http://central.maven.org/maven2/org/apache/pig/piggybank/0.15.0/piggybank-0.15.0.jar

CMD ["/etc/bootstrap.sh", "-d"]

#    apt-get remove -y cassandra && \
#    apt-get remove -y mongodb-org

# end of actual build

# beginning of works in progress

# spark cassandra connector - work in progress, it's tricky
# might need to start cassandra and spark daemons before doing this
# https://www.codementor.io/sheena/installing-cassandra-spark-linux-debian-ubuntu-14-du107vbhx
# https://coderwall.com/p/o9bkjg/setup-spark-with-cassandra-connector

#RUN git clone ${SPARK_CASSANDRA_URL} && \
#    cd spark-cassandra-connector && \
#    git checkout v${SPARK_CASSANDRA_VERSION}2.0.1 && \
#    ./sbt/sbt assembly -Dscala-2.11=true
    
#$SPARK_HOME/bin/spark-shell --packages datastax:spark-cassandra-connector:1.6.6-s_2.10
#$SPARK_HOME/bin/spark-shell --packages datastax:spark-cassandra-connector:2.0.1-s_2.11
#$SPARK_HOME/bin/spark-submit --packages datastax:spark-cassandra-connector:2.0.1-s_2.11

# Dataframes (Requires the Spark Cassandra Connector)
#sqlContext.read\
#    .format("org.apache.spark.sql.cassandra")\
#    .options(table="kv", keyspace="test")\
#    .load().show()
#RDDs (Requires Pyspark-Cassandra)
#sc.cassandraTable("keyspace", "table")    

#    sed -i 's/\/var\/lib\/mongodb/\/data\/mongo\/data/' /etc/mongod.conf && 
#    sed -i 's/\/var\/log\/mongodb\/mongod.log/\/data\/mongo\/log.txt/' /etc/mongod.conf && \

# mongod --dbpath /data/host/mongo/data --logpath /data/host/mongo/log.txt &    

# mongodo --dbpath /data/host/mongo
#mongo
#use joey
#name = {"first":"joey", "last":"gagliardo"}
#db.names.insert(name)
#db.names.find()
#python
#from pymongo import MongoClient
#client = MongoClient()
#db = client.joey
#list(db.names.find())
    
#RUN echo "[Unit]" > /lib/systemd/system/mongod.service && \
#    echo "Description=High-performance, schema-free document-oriented database" > /lib/systemd/system/mongod.service && \
#    echo "After=network.target" > /lib/systemd/system/mongod.service && \
#    echo "Documentation=https://docs.mongodb.org/manual" > /lib/systemd/system/mongod.service &&
#    cd /lib/systemd/system && \
#    systemctl daemon-reload && \
#    systemctl start mongod && \
#    systemctl enable mongod 
    

#RUN echo ${MONGO_URL}
#https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.4.tgz

#RUN curl -O ${MONGO_URL} | tar -zx -C /usr/local
#RUN mkdir -p /data/db
#    ln -s /usr/local/
#    export PATH=/usr/local/bin:$PATH

#curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.4.tgz
#tar -zxvf mongodb-linux-x86_64-3.4.4.tgz
#mkdir -p mongodb
#cp -R -n mongodb-linux-x86_64-3.4.4/ mongodb
#export PATH=<mongodb-install-directory>/bin:$PATH
#mkdir -p /data/db

# spark mongo
# git clone https://github.com/mongodb/mongo-spark.git
# cd mongo-spark
# ./sbt check

# to do

#create keyspace joey with replication = {'class':'SimpleStrategy', 'replication_factor': 3};
#use joey;
#create table names (id int PRIMARY KEY, name varchar);
#insert into names (id, name) values (1, 'joey');

#from cassandra.cluster import Cluster
#cluster = Cluster()
#session = cluster.connect('joey')
#rows = session.execute('SELECT id, name FROM names')
#list(rows)

# maybe?
#sudo service cassandra stop
#sudo service cassandra start

# on first startup of a container you need to run /scripts/format_namenode.sh and /scripts/initschema.sh

# 1. Build image
# docker build -t joey/hadoop -f HadoopOnUbuntu.txt .
# 2. Build container and launch a bash shell
# docker run --name hadoop-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -it joegagliardo/hadoop /etc/bootstrap.sh -bash
# 3. Build container and map a local drive to the /data/host 
# docker run --name bigdata-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -v "$HOME/docker/:/data/host" -it joegagliardo/bigdata /etc/bootstrap.sh -bash
# 4. Restart and attach to container
# docker start hadoop-client
# docker attach hadoop-client

# IMAGEID=some image number you get from docker images
# docker run --name bigdata-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -v "/Users/joey/Dev/:/data/host" -it $IMAGEID /etc/bootstrap.sh -bash
# rename a docker image
# docker tag d583c3ac45fd myname/server:latest



# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q) -f
  
# docker run --name bigdata-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -v "$HOME/docker/:/data/host" -v "$HOME/docker/hdfs/:/home/hdfs"  -it joegagliardo/bigdata /etc/bootstrap.sh -bash


# CREATE KEYSPACE test WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1 };
# CREATE TABLE test.kv(key text PRIMARY KEY, value int);
#INSERT INTO test.kv(key, value) VALUES ('key1', 1);
#INSERT INTO test.kv(key, value) VALUES ('key2', 2);


#-v "$HOME/docker/mysql/:/var/lib/mysql" 


# alias newbd="if [ \"$(docker ps -q -f name=bigdata-client)\" ]; then docker rm bigdata-client -f; fi && docker run --name bigdata-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -v \"$HOME/docker/:/data/host\" -it joegagliardo/bigdata /etc/bootstrap.sh -bash"

#docker run --name bigdata-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -v "$HOME/docker/:/data/host" -it joegagliardo/bigdata /etc/bootstrap.sh -bash

# alias newbd="docker run --name bigdata-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -v \"$HOME/docker/:/data/host\" -it joegagliardo/bigdata /etc/bootstrap.sh -bash"
# alias attachbd="docker start bigdata-client && docker attach bigdata-client"
# docker run --name bigdata-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -v "$HOME/docker/:/data/host" -it 435d885aa7dc /etc/bootstrap.sh -bash




# https://github.com/dropbox/PyHive.git
# python setup.py install
# python3 setup.py install


#import findspark
#findspark.init()

#import pyspark
#sc = pyspark.SparkContext(appName="myAppName")


#RUN url_exists() { \
#if curl -s --head $1 | head -n 1 | grep "HTTP/1.[01] [2].." ; then \
#  echo "File exists $1" \
#  urlexists="YES" \
#else \
#  echo "File does not exist $1" \
#  urlexists="NO" \
#  exit 1 \
#fi \
#} && \
#urlexists ${HADOOP_URL} 

#&& \
#urlexists ${PIG_URL} && \
#urlexists ${HIVE_URL} && \
#urlexists ${SPARK_URL} && \
#urlexists ${HBASE_URL} && \
#urlexists ${MONGO_URL} && \
#urlexists ${CASSANDRA_URL} && \
#urlexists ${SPARK_CASSANRDRA_URL}

#	wget http://dl.bintray.com/spark-packages/maven/datastax/spark-cassandra-connector/2.0.1-s_2.11/spark-cassandra-connector-2.0.1-s_2.11.jar && \
#    mv spark-cassandra-connector-2.0.1-s_2.11.jar /usr/local/spark/jars && \
#	ln -s /usr/local/spark/jars/spark-cassandra-connector-2.0.1-s_2.11.jar /usr/local/spark/jars/spark-cassandra-connector.jar && \

# RUN apt-get -yq install vim postgresql-9.3 libpostgresql-jdbc-java


# pyspark --packages datastax:spark-cassandra-connector:1.6.7-s_2.11


# curl -LO https://fastdl.mongodb.org/osx/mongodb-osx-x86_64-3.4.0.tgz
# curl -LO https://fastdl.mongodb.org/osx/mongodb-osx-x86_64-3.4.0.tgz.sig
# curl -LO https://www.mongodb.org/static/pgp/server-3.4.asc
# gpg --import server-3.4.asc
# gpg --verify mongodb-osx-x86_64-3.4.0.tgz.sig mongodb-osx-x86_64-3.4.0.tgz



#	echo "# Mongo-Spark" && \
#    cd /home && \
#    git clone https://github.com/mongodb/mongo-spark.git && \
#    cd mongo-spark && \
#    ./sbt check && \
#    ./sbt +publish-signed && \
#    ./sbt +spPublish && \


# curl -LO https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-3.4.5.tgz
# curl -LO https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-3.4.5.tgz.sha256
# shasum -c mongodb-linux-x86_64-ubuntu1604-3.4.5.tgz.sha256


# wget --content-disposition http://search.maven.org/remotecontent?filepath=org/mongodb/mongo-hadoop/mongo-hadoop-core/2.0.2/mongo-hadoop-core-2.0.2.jar
# wget --content-disposition http://search.maven.org/remotecontent?filepath=org/mongodb/mongo-hadoop/mongo-hadoop-pig/2.0.2/mongo-hadoop-pig-2.0.2.jar
# wget --content-disposition http://search.maven.org/remotecontent?filepath=org/mongodb/mongo-hadoop/mongo-hadoop-hive/2.0.2/mongo-hadoop-hive-2.0.2.jar
# wget --content-disposition http://search.maven.org/remotecontent?filepath=org/mongodb/mongo-hadoop/mongo-hadoop-spark/2.0.2/mongo-hadoop-spark-2.0.2.jar
# wget --content-disposition http://search.maven.org/remotecontent?filepath=org/mongodb/mongo-hadoop/mongo-hadoop-streaming/2.0.2/mongo-hadoop-streaming-2.0.2.jar
# wget --content-disposition http://search.maven.org/remotecontent?filepath=org/mongodb/mongo-java-driver/3.4.2/mongo-java-driver-3.4.2.jar

### wget --content-disposition http://search.maven.org/remotecontent?filepath=org/mongodb/mongodb-driver/3.4.2/mongodb-driver-3.4.2.jar
## wget --content-disposition https://oss.sonatype.org/content/repositories/releases/org/mongodb/mongo-java-driver/3.4.2/mongo-java-driver-3.4.2.jar
## wget --content-disposition 

#register mongo-hadoop-core-2.0.2.jar;
#register mongo-hadoop-pig-2.0.2.jar;
#register mongo-hadoop-core.jar;
#register mongo-hadoop-pig.jar;
#x = load 'mongodb://localhost:27017/prod1.prod1' USING com.mongodb.hadoop.pig.MongoLoader;
#x = load 'mongodb://localhost:27017/prod1.prod1' USING com.mongodb.hadoop.pig.MongoLoader('id, price, man', 'id');
#store x into 'mongodb://localhost:27017/prod1.prod2' USING com.mongodb.hadoop.pig.MongoInsertStorage('', '' );


#add jar mongo-hadoop-core-2.0.2.jar;
#add jar mongo-java-driver-3.4.2.jar;
#dd jar mongo-hadoop-hive-2.0.2.jar;

#add jar mongodb-driver-3.4.2.jar;


#CREATE EXTERNAL TABLE prod1
#( 
#  id INT,
#  man STRING,
#  price FLOAT)
#STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
#TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/prod1.prod1');

#CREATE EXTERNAL TABLE prod1
#( 
#  id INT,
#  man STRING,
#  price FLOAT)
#STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
#WITH SERDEPROPERTIES('mongo.columns.mapping'='{"id":"_id", "man":"man", "price":"price"}')
#TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/prod1.prod1');


# wget --content-disposition 

# mv *.jar mongo-hadoop-streaming.2.0.2.jar




