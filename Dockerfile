FROM joegagliardo/ubuntu
MAINTAINER joegagliardo

# MYSQL Passwords
ARG HIVEUSER_PASSWORD=hivepassword
ARG MYSQLROOT_PASSWORD=rootpassword

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

ARG HBASE_VERSION=1.2.5
ARG HBASE_BASE_URL=http://apache.mirrors.pair.com/hbase
ARG HBASE_URL=${HBASE_BASE_URL}/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz 

ARG MONGO_VERSION=3.4.4
ARG MONGO_BASE_URL=https://fastdl.mongodb.org/linux
ARG MONGO_URL=${MONGO_BASE_URL}/mongodb-linux-x86_64-${MONGO_VERSION}.tgz

ARG CASSANDRA_VERSION=310
ARG CASSANDRA_URL=http://www.apache.org/dist/cassandra

ARG SPARK_CASSANDRA_VERSION=2.0.1
ARG SPARK_CASSANRDRA_URL=https://github.com/datastax/spark-cassandra-connector.git

USER root

# passwordless ssh
RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key /root/.ssh/id_rsa && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# Make folders for HDFS data
RUN mkdir /home/hdfs

# Hadoop
RUN echo ${HADOOP_URL}
RUN curl -s ${HADOOP_URL} | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./hadoop-${HADOOP_VERSION} hadoop

ENV HADOOP_PREFIX /usr/local/hadoop
RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
#RUN . $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

RUN mkdir $HADOOP_PREFIX/input && \
    cp $HADOOP_PREFIX/etc/hadoop/*.xml $HADOOP_PREFIX/input

# pseudo distributed
RUN echo "  <configuration>" > $HADOOP_PREFIX/etc/hadoop/core-site.xml.template && \
    echo "      <property>" >> $HADOOP_PREFIX/etc/hadoop/core-site.xml.template && \
    echo "          <name>fs.defaultFS</name>" >> $HADOOP_PREFIX/etc/hadoop/core-site.xml.template && \
    echo "          <value>hdfs://HOSTNAME:9000</value>" >> $HADOOP_PREFIX/etc/hadoop/core-site.xml.template && \
    echo "      </property>" >> $HADOOP_PREFIX/etc/hadoop/core-site.xml.template && \
    echo "  </configuration>" >> $HADOOP_PREFIX/etc/hadoop/core-site.xml.template && \
    sed s/HOSTNAME/localhost/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml

RUN echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $HADOOP_PREFIX//etc/hadoop/hdfs-site.xml && \
    echo "<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "<configuration>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "  <property>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "       <name>dfs.replication</name>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "       <value>1</value>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "   </property>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "   <property>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "       <name>dfs.namenode.name.dir</name>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "       <value>file:/home/hdfs/name</value>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "   </property>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "   <property>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "       <name>dfs.datanode.data.dir</name>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "       <value>file:/home/hdfs/data</value>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "   </property>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
    echo "</configuration>" >> $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml 

RUN echo "<configuration>" > $HADOOP_PREFIX/etc/hadoop/mapred-site.xml && \
    echo "    <property>" >> $HADOOP_PREFIX/etc/hadoop/mapred-site.xml && \
    echo "        <name>mapreduce.framework.name</name>" >> $HADOOP_PREFIX/etc/hadoop/mapred-site.xml && \
    echo "        <value>yarn</value>" >> $HADOOP_PREFIX/etc/hadoop/mapred-site.xml && \
    echo "    </property>" >> $HADOOP_PREFIX/etc/hadoop/mapred-site.xml && \
    echo "</configuration>" >> $HADOOP_PREFIX/etc/hadoop/mapred-site.xml 

RUN echo "<configuration>" > $HADOOP_PREFIX/etc/hadoop/yarn-site.xml && \
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
    echo "</configuration>" >> $HADOOP_PREFIX/etc/hadoop/yarn-site.xml

#RUN $HADOOP_PREFIX/bin/hdfs namenode -format

RUN echo "Host *" > /root/.ssh/config && \
    echo "  UserKnownHostsFile /dev/null" >> /root/.ssh/config && \
    echo "  StrictHostKeyChecking no" >> /root/.ssh/config && \
    echo "  LogLevel quiet" >> /root/.ssh/config && \
    echo "  Port 2122" >> /root/.ssh/config 

RUN chmod 600 /root/.ssh/config && \
    chown root:root /root/.ssh/config

# # installing supervisord
# Not sure if I need this yet
# RUN apt-get install -y python-setuptools
# RUN easy_install pip
# RUN curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py -o - | python
# RUN pip install supervisor
#
# ADD supervisord.conf /etc/supervisord.conf

RUN echo '#!/bin/bash' > /etc/bootstrap.sh && \
    echo '' >> /etc/bootstrap.sh && \
    echo ': ${HADOOP_PREFIX:=/usr/local/hadoop}' >> /etc/bootstrap.sh && \
    echo '' >> /etc/bootstrap.sh && \
    echo '$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh' >> /etc/bootstrap.sh && \
    echo '' >> /etc/bootstrap.sh && \
    echo 'rm /tmp/*.pid' >> /etc/bootstrap.sh && \
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
    echo 'fi' >> /etc/bootstrap.sh

RUN chown root:root /etc/bootstrap.sh && \
    chmod 700 /etc/bootstrap.sh
ENV BOOTSTRAP /etc/bootstrap.sh

# working around docker.io build error
RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh
RUN chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh
RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config

RUN service ssh start     $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh     $HADOOP_PREFIX/sbin/start-dfs.sh     $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/root
RUN service ssh start     $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh     $HADOOP_PREFIX/sbin/start-dfs.sh     $HADOOP_PREFIX/bin/hdfs dfs -put $HADOOP_PREFIX/etc/hadoop/ input

CMD ["/etc/bootstrap.sh", "-d"]

# Pig
RUN echo ${PIG_URL}
RUN curl ${PIG_URL} | tar -zx -C /usr/local && \
    ln -s /usr/local/pig-${PIG_VERSION} /usr/local/pig
ENV PIG_HOME /usr/local/pig
ENV PATH /usr/local/hadoop/bin:/usr/local/hadoop/sbin:$PATH
ENV PATH /usr/local/pig/bin:$PATH

# Hive
RUN echo ${HIVE_URL}
RUN curl ${HIVE_URL} | tar -zx -C /usr/local && \
     ln -s /usr/local/apache-hive-${HIVE_VERSION}-bin /usr/local/hive
ENV HIVE_HOME /usr/local/hive
ENV PATH /usr/local/hive/bin:$PATH
#RUN ln -s /usr/share/java/f-connector-java.jar $HIVE_HOME/lib/mysql-connector-java.jar
RUN ln -s /usr/share/java/mysql-connector-java.jar /usr/local/hive/lib/mysql-connector-java.jar

#    echo "      <value>jdbc:mysql://localhost/metastore?createDatabaseIfNotExist=true</value>" >> /usr/local/hive/conf/hive-site.xml && \

RUN echo "<configuration>" > /usr/local/hive/conf/hive-site.xml && \
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
    echo "</configuration>" >> /usr/local/hive/conf/hive-site.xml 

# Format Name Node
RUN cd /home && \
    echo "#! /bin/sh" > /home/scripts/format_namenode.sh && \
    echo "stop-all.sh" >> /home/scripts/format_namenode.sh && \
    echo "rm -r /home/hdfs/name" >> /home/scripts/format_namenode.sh && \
    echo "rm -r /home/hdfs/data" >> /home/scripts/format_namenode.sh && \
    echo "hdfs namenode -format" >> /home/scripts/format_namenode.sh && \
    echo "start-all.sh" >> /home/scripts/format_namenode.sh && \
    echo "hadoop fs -mkdir /user" >> /home/scripts/format_namenode.sh && \
    echo "hadoop fs -mkdir /user/hive" >> /home/scripts/format_namenode.sh && \
    echo "hadoop fs -mkdir /user/hive/warehouse" >> /home/scripts/format_namenode.sh && \
    echo "hadoop fs -mkdir /tmp" >> /home/scripts/format_namenode.sh && \
    echo "hadoop fs -chmod g+w /user/hive/warehouse" >> /home/scripts/format_namenode.sh && \
    echo "hadoop fs -chmod g+w /tmp" >> /home/scripts/format_namenode.sh && \
    chmod +x /home/scripts/format_namenode.sh
#RUN /home/scripts/format_namenode.sh

RUN echo "#! /bin/sh" > /home/scripts/exitsafemode.sh && \
    echo "hdfs dfsadmin -safemode leave" >> /home/scripts/exitsafemode.sh && \
    echo "chmod +x /home/scripts/exitsafemode.sh" >> /home/scripts/exitsafemode

# MySQL script to create the Hive metastore and user and then initialize the schema
RUN echo "create database metastore; CREATE USER 'hiveuser'@'%' IDENTIFIED BY '${HIVEUSER_PASSWORD}'; GRANT all on *.* to 'hiveuser'@localhost identified by '${HIVEUSER_PASSWORD}'; flush privileges;" > /home/scripts/hiveuser.sql

RUN echo "#! /bin/sh" > /home/scripts/initschema.sh && \
    echo "mysql < /home/scripts/hiveuser.sql" >> /home/scripts/initschema.sh && \
    echo "schematool -dbType mysql -initSchema" >> /home/scripts/initschema.sh && \
    chmod +x /home/scripts/initschema.sh
#RUN /home/scripts/initschema.sh

# Spark
RUN echo ${SPARK_URL}
RUN curl ${SPARK_URL} | tar -zx -C /usr/local
RUN ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop2.7 /usr/local/spark && \
    ln -s /usr/local/hive/conf/hive-site.xml /usr/local/spark/conf/hive-site.xml
ENV SPARK_HOME /usr/local/spark
ENV PATH /usr/local/spark/bin:$PATH
#RUN cd /usr/local/spark && build/mvn -DskipTests clean package 
RUN ln -s /usr/share/java/mysql-connector-java.jar /usr/local/spark/conf/mysql-connector-java.jar
ENV SPARK_CLASSPATH '/usr/local/spark/conf/mysql-connector-java.jar'
ENV PYTHONPATH ${SPARK_HOME}/python/:$(echo ${SPARK_HOME}/python/lib/py4j-*-src.zip):${PYTHONPATH}
    
# HBase
RUN echo ${HBASE_URL}
RUN curl ${HBASE_URL} | tar -zx -C /usr/local && \
     ln -s /usr/local/hbase-${HBASE_VERSION} /usr/local/hbase
ENV HBASE_HOME /usr/local/hbase
ENV HBASE_CONF_DIR=$HBASE_HOME/conf
ENV PATH /usr/local/hbase/bin:$PATH

RUN echo "<configuration>" > ${HBASE_CONF_DIR}/hbase-site.xml && \
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
    echo "</configuration>" >> ${HBASE_CONF_DIR}/hbase-site.xml
    
RUN git clone https://github.com/hortonworks-spark/shc.git && \
    cd shc && \
    mvn package -DskipTests && \
    mvn clean package test && \
    mvn -DwildcardSuites=org.apache.spark.sql.DefaultSourceSuite test
        
#RUN pip2 install happybase && \
#    pip3 install happybase

# Cassandra
#RUN echo "deb ${CASSANDRA_URL}http://www.apache.org/dist/cassandra/debian ${CASSANDRA_VERSION}x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
#RUN curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
#ARG CASSANDRA_URL=http://www.apache.org/dist/cassandra
RUN echo ${CASSANDRA_URL}
RUN echo "deb ${CASSANDRA_URL}/debian ${CASSANDRA_VERSION}x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
RUN curl ${CASSANDRA_URL}/KEYS | sudo apt-key add -
RUN apt-get update && \
    apt-get install -y cassandra    
RUN echo "#! /bin/sh" > /home/scripts/start-cassandra.sh && \
    echo "cassandra -p /home/scripts/cassandra_processid -R" >> /home/scripts/start-cassandra.sh && \
    chmod +x /home/scripts/start-cassandra.sh
RUN echo "#! /bin/sh" > /home/scripts/stop-cassandra.sh && \
    echo "kill -9 \$(cat /home/scripts/cassandra_processid)" >> /home/scripts/stop-cassandra.sh && \
    echo "rm scripts/cassandra_processid" >> /home/scripts/stop-cassandra.sh && \
    chmod +x /home/scripts/stop-cassandra.sh

# change the data and log folder
RUN mkdir /home/cassandra && \
    mkdir /home/cassandra/data && \
    mkdir /home/cassandra/log
RUN sed -i 's/    - \/var\/lib\/cassandra\/data/    - \/home\/cassandra\/data/g' /etc/cassandra/cassandra.yaml 
RUN sed -i 's/commitlog_directory: \/var\/lib\/cassandra\/commitlog/commitlog_directory: \/home\/cassandra\/log/g' /etc/cassandra/cassandra.yaml 

RUN echo "create keyspace joey with replication = {'class':'SimpleStrategy', 'replication_factor': 3};" > /home/scripts/create-cassandra-table.cql && \
    echo "use joey;" >> /home/scripts/create-cassandra-table.cql && \
    echo "create table names (id int PRIMARY KEY, name varchar);" >> /home/scripts/create-cassandra-table.cql && \
    echo "insert into names (id, name) values (1, 'joey');" >> /home/scripts/create-cassandra-table.cql && \
    echo "#! /usr/bin/python" > /home/scripts/test-cassandra-table.py && \
    echo "from cassandra.cluster import Cluster" >> /home/scripts/test-cassandra-table.py && \
    echo "cluster = Cluster()" >> /home/scripts/test-cassandra-table.py && \
    echo "session = cluster.connect('joey')" >> /home/scripts/test-cassandra-table.py && \
    echo "rows = session.execute('SELECT id, name FROM names')" >> /home/scripts/test-cassandra-table.py && \
    echo "print list(rows)" >> /home/scripts/test-cassandra-table.py && \
    echo "chmod +x /home/scripts/test-cassandra-table.py"

RUN pip2 install cassandra-driver && \
    pip3 install cassandra-driver

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

# Mongo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 && \
    echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list && \
    apt-get update && \
    apt-get install -y mongodb-org && \
    pip2 install pymongo && \
    pip3 install pymongo && \
    echo "#! /bin/sh" > /home/scripts/start-mongo.sh && \
    echo "mongod --dbpath /home/mongo/data --logpath /home/mongo/log.txt &" >> /home/scripts/start-mongo.sh && \
    chmod +x /home/scripts/start-mongo && \
    echo "#! /bin/sh" > /home/scripts/stop-mongo.sh && \
    echo "mongod --shutdown --dbpath /home/mongo/data" >> /home/scripts/stop-mongo.sh && \
    chmod +x /home/scripts/stop-mongo

#    sed -i 's/\/var\/lib\/mongodb/\/home\/mongo\/data/' /etc/mongod.conf && 
#    sed -i 's/\/var\/log\/mongodb\/mongod.log/\/home\/mongo\/log.txt/' /etc/mongod.conf && \

# mongod --dbpath /home/mongo/data --logpath /home/mongo/log.txt &    

# mongodo --dbpath /home/mongo
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

# on first startup of a container you need to run /home/scripts/format_namenode.sh and /home/scripts/initschema.sh

# 1. Build image
# docker build -t joey/hadoop -f HadoopOnUbuntu.txt .
# 2. Build container and launch a bash shell
# docker run --name hadoop-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -it joegagliardo/hadoop /etc/bootstrap.sh -bash
# 3. Build container and map a local drive to the /home/host & /home/hdfs folder inside the container
# docker run --name bigdata-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -v "$HOME/docker/:/home/host" -v "$HOME/docker/hdfs/:/home/hdfs"  -it joegagliardo/bigdata /etc/bootstrap.sh -bash
# 4. Restart and attach to container
# docker start hadoop-client
# docker attach hadoop-client

# IMAGEID=some image number you get from docker images
# docker run --name bigdata-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -v "/Users/joey/Dev/:/home/host" -it $IMAGEID /etc/bootstrap.sh -bash
# rename a docker image
# docker tag d583c3ac45fd myname/server:latest



# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q) -f
  
# docker run --name bigdata-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -v "$HOME/docker/:/home/host" -v "$HOME/docker/hdfs/:/home/hdfs"  -it joegagliardo/bigdata /etc/bootstrap.sh -bash


#-v "$HOME/docker/mysql/:/var/lib/mysql" 

# alias startbdc="docker run --name bigdata-client -p 50070:50070 -p 8088:8088 -p 10020:10020 -v \"$HOME/docker/:/home/host\" -v \"$HOME/docker/hdfs/:/home/hdfs\"  -v \"$HOME/docker/cassandra/:/home/cassandra\" -v \"$HOME/docker/mongo/data/:/home/mongo/data\" -it joegagliardo/bigdata /etc/bootstrap.sh -bash"

