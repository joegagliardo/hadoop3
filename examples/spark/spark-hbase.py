#! /usr/bin/python
# spark-submit --jars "/usr/local/spark/jars/spark-xml.jar" /examples/spark/spark3.py
# not been able to make this one work just yet

import platform
import findspark
findspark.init()
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext
from pyspark.sql.types import *
conf = SparkConf().setAppName("spark3").setMaster("local")
sc = SparkContext(conf=conf)
spark = SQLContext(sc)
sc.setLogLevel("ERROR")

data_source_format = 'org.apache.spark.sql.execution.datasources.hbase'

df = sc.parallelize([('a', '1.0'), ('b', '2.0')]).toDF(schema=['col0', 'col1'])

# ''.join(string.split()) in order to write a multi-line JSON string here.
catalog = ''.join("""{
    "table":{"namespace":"default", "name":"testtable"},
    "rowkey":"key",
    "columns":{
        "col0":{"cf":"rowkey", "col":"key", "type":"string"},
        "col1":{"cf":"cf", "col":"col1", "type":"string"}
    }
}""".split())


# Writing
#df.write.options(catalog=catalog).format(data_source_format).save()

# Reading
#df = spark.read.options(catalog=catalog).format(data_source_format).load()
#df.show()


catalog = ''.join("""{
    "table":{"namespace":"default", "name":"blogposts"},
    "rowkey":"key",
    "columns":{
        "key":{"cf":"rowkey", "col":"key", "type":"string"},
        "author":{"cf":"post", "col":"author", "type":"string"},
        "body":{"cf":"post", "col":"body", "type":"string"}
        "head":{"cf":"post", "col":"head", "type":"string"}
        "title":{"cf":"post", "col":"title", "type":"string"}
    }
}""".split())
df = spark.read.options(catalog=catalog).format(data_source_format).load()
df.show()




hTbl = spark.read.format('org.apache.hadoop.hbase.spark') \
       .option('hbase.table','t') \
       .option('hbase.columns.mapping', 'KEY_FIELD STRING :key, A STRING c:a, B STRING c:b') \
       .option('hbase.use.hbase.context', False) \
       .option('hbase.config.resources', 'file:///usr/local/hbase/conf/hbase-site.xml') \
       .load()
       