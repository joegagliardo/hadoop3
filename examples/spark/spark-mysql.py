#! /usr/bin/python
# spark-submit /examples/spark/spark-mysql.py
import platform
import findspark
findspark.init()
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext
from pyspark.sql.types import *
conf = SparkConf().setAppName("spark-mysql").setMaster("local")
sc = SparkContext(conf=conf)
spark = SQLContext(sc)
sc.setLogLevel("ERROR")
log4j = sc._jvm.org.apache.log4j
log4j.LogManager.getRootLogger().setLevel(log4j.Level.ERROR)

import mysql.connector
import sys


# create a northwind database and regions table in mysql first
# create database northwind;
# use northwind;
# create table regions (RegionID int, RegionName varchar(30));

try:
	cn = mysql.connector.connect(host='localhost', user='root', password='rootpassword')
	cursor = cn.cursor()
	cursor.execute('create database if not exists northwind')
	cn.close()

	cn = mysql.connector.connect(host='localhost', user='root', password='rootpassword', database='northwind')
	cursor = cn.cursor()
	cursor.execute('drop table if exists regions')
	cn.close()
except:
	pass

# set up a properties dictionary for use with spark jdbc
# properties = {'user' : 'root', 'password' : 'rootpassword'}

# read a CSV file into a data frame
regions = spark.read.csv('file:///examples/northwind/CSVHeaders/regions', header=True) 
regions.show()

# write the data frame into a mysql table
#regions.write.jdbc("jdbc:mysql://localhost/northwind", table='regions', mode = 'append', properties=properties)
regions.write.format("jdbc").options(url="jdbc:mysql://localhost/northwind", driver='com.mysql.jdbc.Driver', dbtable='regions', user='root', password = "rootpassword", mode = "append", useSSL = "false").save()
# select * from regions;

# read a mysql table into a data frame
x = spark.read.format("jdbc").options(url="jdbc:mysql://localhost/northwind", driver="com.mysql.jdbc.Driver", dbtable= "regions", user="root", password="rootpassword").load()
x.show()

# use the mysql dataframe as a temporary spark table
x.createOrReplaceTempView("regions")

# read territories from a text file
territories = spark.read.json('/examples/northwind/JSON/territories')
territories.createOrReplaceTempView("territories")

# run an HQL query in spark on the data populated from the mysql table
spark.sql("select r.RegionID, r.RegionName, t.TerritoryID, t.TerritoryName from regions as r join territories as t on r.RegionID = t.RegionID ORDER BY r.RegionID, t.TerritoryID").show()
t = spark.sql("select r.RegionID, r.RegionName, collect_set(t.TerritoryName) as TerritoryList from regions as r join territories as t on r.RegionID = t.RegionID GROUP BY r.RegionID, r.RegionName ORDER BY r.RegionID")
t.show()

# write the results as a JSON file
hostname = platform.node()
port = 9000
folder = '/territories'

region_territory_path = 'hdfs://{0}:{1}/{2}'.format(hostname, port, 'region_territory')
t.write.json(region_territory_path)

rt = spark.read.json(region_territory_path)
rt.createOrReplaceTempView("region_territory")
spark.sql("select r.RegionID, r.RegionName, tl as TerritoryName from region_territory as r LATERAL VIEW explode(TerritoryList) exploded_table as tl").show()


