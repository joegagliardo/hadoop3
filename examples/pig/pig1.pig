region1 = load '/examples/northwind/CSV_NoHeaders/regions.csv' using PigStorage(',');
dump region1

region2 = foreach region1 generate $0, UPPER($1);
dump region2;

region1 = load '/examples/northwind/CSV_Headers/regions.csv' using PigStorage(',') AS (RegionID:int, RegionName:chararray);
region2 = foreach region1 generate RegionID, LTRIM(RTRIM(RegionName));
dump region2;

region3 = filter region2 by RegionID IS NOT NULL;
dump region3;

store region3 into 'pig_region1';
sh cat pig_region1/*
 
store region3 into 'pig_region2' using PigStorage('|');
sh cat pig_region2/*

terr1 = load '/examples/northwind/CSV_NoHeaders/territories.csv' using PigStorage(',') as (TerritoryID:int, TerritoryName:chararray, RegionID:int);
dump terr1;

store terr1 into 'terr_json' using JsonStorage();
sh cat terr_json/*

terr3 = load 'terr_json' using JsonLoader();
describe terr3;
dump terr3;

terr4 = group terr3 by RegionID;
describe terr4;
dump terr4;

terr5 = foreach terr4 generate group as RegionID, terr3 as TerritoryList;
dump terr5;

terr6 = foreach terr5 generate RegionID, COUNT(TerritoryList) AS Cnt;
dump terr6;

terr7 = foreach terr5 generate RegionID, TerritoryList.(TerritoryID, TerritoryName);
dump terr7;

store terr7 into 'terr_json2' using JsonStorage();
sh cat terr_json2/*

REGISTER /usr/local/pig/lib/avro-1.7.5.jar
t = load '/examples/northwind/CSV_NoHeaders/territories.csv' using PigStorage(',') as (ID:int, Name:chararray, Region:int);
store t into 'terr_avro' using AvroStorage();

sh cat terr_avro/*
