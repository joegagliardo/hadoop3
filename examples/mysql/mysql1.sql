create database northwind;
use northwind;
create table regions (regionid int, regionname varchar(30));
insert into regions select 1, 'North' union all select 2, 'South' union all select 3, 'East' union all select 4, 'West';
