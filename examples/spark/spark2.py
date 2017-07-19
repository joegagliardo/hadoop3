#! /usr/bin/python
import platform
import findspark
findspark.init()
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext
from pyspark.sql.types import *
conf = SparkConf().setAppName("spark2").setMaster("local")
sc = SparkContext(conf=conf)
spark = SQLContext(sc)
sc.setLogLevel("ERROR")

hostname = platform.node()
port = 9000
folder = 'shakespeare.txt'
path = 'hdfs://{0}:{1}/{2}'.format(hostname, port, folder)
lines = sc.textFile(path)
lines2 = lines.map(lambda x : (len(x.split(' ')), x.split(' ')))
lines3 = lines2.flatMapValues(lambda x : x)
searchwords = sc.parallelize([('king', 1), ('queen', 1)])
lines4 = lines3.map(lambda x : (x[1], x[0]))
searchwords.collect()
join1 = searchwords.join(lines4)
path = 'hdfs://{0}:{1}/{2}'.format(hostname, port, 'spark2')
join1.reduceByKey(lambda x, y : x if x[1] > y[1] else y).map(lambda x : (x[0], x[1][1])).saveAsTextFile(path)

#spark-submit --class com.roi.hadoop.grepnumwords.Main target/grepnumwords-1.0.0.jar hdfs://$HOSTNAME:9000/shakespeare.txt /spark3 king queen sword
#spark-submit --class com.roi.hadoop.grepnumwords.Main target/grepnumwords-1.0.0.jar hdfs://$HOSTNAME:9000/shakespeare.txt hdfs://$HOSTNAME:9000/spark3 king queen sword
#spark-submit spark2.py
