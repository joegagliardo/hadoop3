#! /usr/bin/python
# spark-submit --jars "/usr/local/spark/jars/spark-xml.jar" /examples/spark/spark3.py

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

products = spark.read.csv('/examples/northwind/CSVHeaders/products/products.csv', header=True) 
products.write \
    .format("com.databricks.spark.xml") \
    .option("rootTag", "products") \
    .option("rowTag", "product") \
    .save("/examples/northwind/products_xml")

products2 = spark.read \
    .format("com.databricks.spark.xml") \
    .options(rootTag="products", rowTag="product") \
    .load("/examples/northwind/products_xml")

productSchema = StructType([ \
    StructField("ProductID", IntegerType(), True), \
    StructField("ProductName", StringType(), True), \
    StructField("SupplierID", IntegerType(), True), \
    StructField("CategoryID", IntegerType(), True), \
    StructField("UnitPrice", DoubleType(), True), \
    StructField("UnitsInStock", IntegerType(), True), \
    StructField("UnitsOnOrder", IntegerType(), True)])

products3 = spark.read \
    .format('com.databricks.spark.xml') \
    .options(rootTag="products", rowTag="product") \
    .load("/examples/northwind/products_xml", schema = productSchema)
    
products.createOrReplaceTempView("products")
products4 = spark.sql("select ProductID, ProductName, SupplierID, CategoryID, UnitPrice, named_struct('InStock', UnitsInStock, 'OnOrder', UnitsOnOrder) as Units FROM products")
products4.write \
    .format("com.databricks.spark.xml") \
    .option("rootTag", "products") \
    .option("rowTag", "product") \
    .save("/examples/northwind/products4_xml")
    
    
products4.createOrReplaceTempView("products4")
products5 = spark.sql('select ProductID, ProductName, SupplierID, CategoryID, UnitPrice, Units.InStock AS UnitsInStock, Units.OnOrder as UnitsOnOrder FROM products4')
products5.show()



