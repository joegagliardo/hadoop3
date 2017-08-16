dfs -mkdir /regions;
dfs -put /examples/northwind/CSVHeaders/regions/regions.csv /regions;

set hive.execution.engine=mr;

CREATE EXTERNAL TABLE Regions(
RegionID int,
RegionName string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/regions';

SELECT * FROM Regions;

SELECT *, INPUT__FILE__NAME FROM Regions;

ALTER TABLE Regions RENAME TO regions_table;

CREATE VIEW regions_view AS SELECT RegionID, LTRIM(RTRIM(RegionName)) AS RegionName FROM regions_table WHERE RegionID IS NOT NULL;

SELECT * FROM regions_view;

CREATE TABLE Regions(
RegionID int,
RegionName string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/examples/northwind/CSV/regions' overwrite into table regions;
SELECT * FROM regions;


CREATE EXTERNAL TABLE regions2(
RegionID int,
RegionName string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/regions'
TBLPROPERTIES("skip.header.line.count"="1");

SELECT * FROM Regions2;

CREATE EXTERNAL TABLE RegionsTab(
RegionID int,
RegionName string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/regionstab';

INSERT INTO RegionsTab SELECT * FROM Regions;

SELECT * FROM RegionsTab;

dfs -cat /regionstab/*;

ADD JAR /usr/local/hive/hcatalog/share/hcatalog/hive-hcatalog-core.jar;

CREATE TABLE territories(
TerritoryID string,
TerritoryName string,
RegionID int)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/territories';

LOAD DATA LOCAL INPATH '/examples/northwind/JSON/territories/territories.json' overwrite into table Territories;

SELECT * FROM territories;


CREATE TABLE Categories
(
CategoryID int,
CategoryName string,
Description string
)
STORED AS AVRO;

LOAD DATA LOCAL INPATH '/examples/northwind/AVRO/categories' overwrite into table Categories;

select * from Categories;

create table Products
(
ProductID int,
ProductName string,
SupplierID int,
CategoryID int,
QuantityPerUnit string,
UnitPrice double,
UnitsInStock int,
UnitsOnOrder int,
ReorderLevel int,
Discontinued boolean
)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/examples/northwind/JSON/products/products.json' overwrite into table Products;

select regionid, collect_set(territoryname) as territorylist
from territories
group by regionid;

create table territories_list
as
select regionid, collect_set(territoryname) as territorylist
from territories
group by regionid;

select * from territories_list;

select t.regionid, l as territoryname
from territories_list as t
LATERAL VIEW explode(territorylist) exploded_table as l;

create table territories_complex as
select regionid
, collect_set(named_struct("territoryid",territoryid, "territoryname", territoryname)) as territorylist
from territories
group by regionid;

select * from territories_complex;

select t.regionid, l
from territories_complex as t
LATERAL VIEW explode(territorylist) exploded_table as l;

select t.regionid, l.territoryname, l.territoryid
from territories_complex as t
LATERAL VIEW explode(territorylist) exploded_table as l;

create table Person(
PersonID int,
Name string,
Skills ARRAY<string>
)
STORED AS AVRO;

INSERT INTO Person 
SELECT 1, 'joey', array('Java', 'Python', 'Hadoop') 
UNION ALL SELECT 2, 'mary', array('C++', 'Java', 'Hive');

select PersonID, Name, Skills from Person;
select PersonID, Name, Skills[0], Skills[1] from Person;

select PersonID, Name, skillname 
from Person LATERAL VIEW explode(Skills) exploded_table as skillname;

create table skills_denormalized as
select PersonID, Name, skillname 
from Person LATERAL VIEW explode(Skills) exploded_table as skillname;

select PersonID, Name, collect_set(skillname) as skills
from skills_denormalized
group by PersonID, Name;

create table Transactions
(ID int,
amount double
)
PARTITIONED BY (Year int);

insert into transactions partition (year=2015) select 1, 10 union all select 2, 20;
dfs -ls /user/hive/warehouse/transactions;

insert into transactions partition (year=2016) select 3,30 union all select 4,40 union all select 5,50;
dfs -ls /user/hive/warehouse/transactions;
 
 
CREATE TABLE RegionTerritories
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE
AS
SELECT r.RegionID, r.RegionName, t.TerritoryID, t.TerritoryName
FROM Regions AS r
JOIN Territories AS t ON r.RegionID = t.RegionID;

