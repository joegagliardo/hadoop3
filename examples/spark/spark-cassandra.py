#! /usr/bin/python
import platform
import findspark
findspark.init()
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext
from pyspark.sql.types import *
conf = SparkConf().setAppName("spark4").setMaster("local")
sc = SparkContext(conf=conf)
spark = SQLContext(sc)

regions = spark.read\
    .format("org.apache.spark.sql.cassandra")\
    .options(table="regions", keyspace="northwind")\
    .load()
regions.show()    
    
regions.createOrReplaceTempView("regions")
spark.sql("select RegionID, UPPER(RegionName) AS RegionName from regions where RegionName like '%o%'").show()

products = spark.read.csv('/data/datasets/northwind/CSV_Headers/products.csv', header=True) 
products.createOrReplaceTempView("products")
products1 = spark.sql('select ProductID as productid, ProductName as productname from Products')
products1.write.format("org.apache.spark.sql.cassandra").options(table="products", keyspace="northwind").save()
products1.write.format("org.apache.spark.sql.cassandra").options(table="products", keyspace = "northwind").save(mode ="append")
table1.write.format("org.apache.spark.sql.cassandra").options(table="othertable", keyspace = "ks").save(mode ="append")

