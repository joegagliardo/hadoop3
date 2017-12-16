CREATE TABLE Regions(
RegionID int,
RegionName string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

LOAD DATA LOCAL INPATH '/examples/northwind/CSV/regions' OVERWRITE INTO TABLE Regions;
SELECT * FROM Regions;

