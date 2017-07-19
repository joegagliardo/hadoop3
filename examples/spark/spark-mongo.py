import platform
import findspark
findspark.init()
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext
from pyspark.sql.types import *
conf = SparkConf().setAppName("spark-mongo").setMaster("local")
sc = SparkContext(conf=conf)
spark = SQLContext(sc)

import sys
sys.path.append('/usr/local/mongo-hadoop/mongo-hadoop/spark/src/main/python')
import pymongo_spark
pymongo_spark.activate()


rdd = sc.mongoRDD('mongodb://localhost:27017/Northwind.products')
print (rdd.collect())

products = spark.createDataFrame(rdd, "ProductID:int, ProductName:string, UnitPrice:float, CategoryID:int, SupplierID:int")
products.createOrReplaceTempView("products")
products1 = spark.sql('select CategoryID, AVG(UnitPrice) as AvgPrice FROM Products GROUP BY CategoryID')
products1.show()
# spark-submit --jars /usr/local/mongo-hadoop/mongo-hadoop-core.jar,/usr/local/mongo-hadoop/mongo-hadoop-spark.jar /data/examples/spark/spark-mongo.py
# pyspark --jars /usr/local/mongo-hadoop/mongo-hadoop-core.jar,/usr/local/mongo-hadoop/mongo-hadoop-spark.jar 
