#! /usr/bin/python

# submit the premade jar to YARN
# hadoop jar grepnumwords/target/grepnumwords-1.0.0.jar com.roi.hadoop.grepnumwords.Main hdfs://$HOSTNAME:9000/shakespeare.txt hdfs://$HOSTNAME:9000/grep_yarn king queen sword
# submit the premade jar to Spark
# spark-submit --class com.roi.hadoop.grepnumwords.Main grepnumwords/target/grepnumwords-1.0.0.jar hdfs://$HOSTNAME:9000/shakespeare.txt hdfs://$HOSTNAME:9000/grep_spark king queen sword
# submit to Spark as a native Spark program
#spark-submit spark2.py

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
searchwords = sc.parallelize([('king', 1), ('queen', 1), ('sword', 1)])
lines4 = lines3.map(lambda x : (x[1], x[0]))
join1 = searchwords.join(lines4)
path = 'hdfs://{0}:{1}/{2}'.format(hostname, port, 'grep_spark2')
join1.reduceByKey(lambda x, y : x if x[1] > y[1] else y).map(lambda x : (x[0], x[1][1])).saveAsTextFile(path)


