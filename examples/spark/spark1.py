# launch a regular python shell and paste the following to get the same thing as pyspark
# findspark is a handy utility that can be found here:
#	git clone https://github.com/minrk/findspark.git
#	cd findspark
#   python setup.py install
# spark-submit spark1.py

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

# depending how things are configured you can maybe just use /territories to find the folder on the hdfs cluster
# but it's usually better to give a specific URL pointing to hdfs://clustername:port/folder
# df = spark.read.json('/territories')

hostname = platform.node()
port = 9000
folder = '/territories'
df = spark.read.json('hdfs://{0}:{1}/{2}'.format(hostname, port, folder))

df.printSchema()
df.show()
df.collect()
df.where(df.RegionID % 2 == 0).select(df.TerritoryID, df.TerritoryName).show()
df.where("RegionID % 2 == 0").select("TerritoryID", "TerritoryName").show()

df.groupBy(df.RegionID).count().show()

df.createOrReplaceTempView("territories")
spark.sql("select TerritoryID, TerritoryName, RegionID from territories where RegionID % 2 == 0").show()
spark.sql("select RegionID, count(*) as Cnt from territories group by RegionID order by Cnt desc").show()

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

