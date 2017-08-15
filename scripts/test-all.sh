/scripts/format-namenode.sh
sleep .5
/scripts/init-schema-postgres.sh
sleep .5
/scripts/start-cassandra.sh
sleep 4
/scripts/start-hbase.sh
sleep 1
/scripts/start-thrift.sh
sleep 1
/scripts/start-mongo.sh
sleep 1
/scripts/start-hiveserver.sh
sleep 1

cqlsh -f /examples/cassandra/create-cassandra-table.cql
cqlsh -f /examples/cassandra/cassandra1.cql
cqlsh -f /examples/cassandra/cassandra2.cql
/examples/cassandra/test-cassandra-table.py
sleep 1

/examples/hbase/blogposts/populate-blogposts.bash
python /examples/hbase/blogposts/test-blogposts.py
/examples/mongo/northwind-mongo.sh
cd /examples/java/grepnumwords
./grepnumwords.sh
cd /examples/java/longestline
./longestline.sh
cd /examples/java/wordcount
./wordcount.sh

pig -x local -f /examples/pig/pig1.pig
cd /examples/spark
spark-submit spark-cassandra.py
spark-submit --jars /usr/local/mongo-hadoop/mongo-hadoop-core.jar,/usr/local/mongo-hadoop/mongo-hadoop-spark.jar /examples/spark/spark-mongo.py
spark-submit spark1.py
spark-submit --jars "/usr/local/spark/jars/spark-xml.jar" /examples/spark/spark2.py

