import platform
import findspark
findspark.init()
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext
from pyspark.sql.types import *
conf = SparkConf().setAppName("spark1").setMaster("local")
sc = SparkContext(conf=conf)
spark = SQLContext(sc)
sc.setLogLevel("ERROR")
log4j = sc._jvm.org.apache.log4j
log4j.LogManager.getRootLogger().setLevel(log4j.Level.ERROR)

properties = {
    "user": "root",
    "password": "rootpassword"
}

# create a northwind database and regions table in mysql first
# create database northwind;
# use northwind;
# create table regions (RegionID int, RegionName varchar(30));

regions = spark.read.csv('file:///examples/northwind/CSV_Headers/regions.csv', header=True) 
regions.show()
regions.write.jdbc("jdbc:mysql://localhost/northwind", table='regions', mode = 'append', properties=properties)
# select * from regions;

x = spark.read.format("jdbc").option("url", "jdbc:mysql://localhost/northwind").option("driver", "com.mysql.jdbc.Driver").option("dbtable", "regions").option("user", "root").option("password", "rootpassword").load()
x.show()

x.createOrReplaceTempView("regions")

spark.sql("select r.RegionID, r.RegionName, t.TerritoryID, t.TerritoryName from regions as r join territories as t on r.RegionID = t.RegionID ORDER BY r.RegionID, t.TerritoryID").show()
t = spark.sql("select r.RegionID, r.RegionName, collect_set(t.TerritoryName) as TerritoryList from regions as r join territories as t on r.RegionID = t.RegionID GROUP BY r.RegionID, r.RegionName ORDER BY r.RegionID")
t.show()
region_territory_path = 'hdfs://{0}:{1}/{2}'.format(hostname, port, 'region_territory')
t.write.json(region_territory_path)

rt = spark.read.json(region_territory_path) 
rt.createOrReplaceTempView("region_territory")
spark.sql("select r.RegionID, r.RegionName, tl as TerritoryName from region_territory as r LATERAL VIEW explode(TerritoryList) exploded_table as tl").show()

