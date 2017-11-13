/scripts/format-namenode.sh
sleep .5
/scripts/init-schema-mysql.sh
sleep .5
/scripts/start-cassandra.sh
sleep 4
start-hbase.sh
sleep 1
/scripts/start-thrift.sh
sleep 1
/scripts/start-mongo.sh
sleep 1
/scripts/start-hiveserver.sh
sleep 1

# cassandra
cqlsh -f /examples/cassandra/create-cassandra-table.cql
cqlsh -f /examples/cassandra/cassandra1.cql
cqlsh -f /examples/cassandra/cassandra2.cql
/examples/cassandra/test-cassandra-table.py
sleep 1

# hbase
/examples/hbase/blogposts/populate-blogposts.bash
python /examples/hbase/blogposts/test-blogposts.py

# mongo
/examples/mongo/northwind-mongo.sh

# java
cd /examples/java/grepnumwords
./grepnumwords.sh
cd /examples/java/longestline
./longestline.sh
cd /examples/java/wordcount
./wordcount.sh

# pig
pig -x local -f /examples/pig/pig1.pig

# hive
cd /examples/hive
/examples/hive/test-hive.sh

# spark
cd /examples/spark
./submit-spark-text.sh
./submit-spark-cassandra.sh
./submit-spark-mongo.sh
./submit-spark-mysql.sh
./submit-spark-xml.sh

