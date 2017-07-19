create keyspace northwind with replication={'class':'SimpleStrategy', 'replication_factor':'1'};

use northwind;

create table Regions (RegionID int primary key, RegionName text);

insert into Regions (RegionID, RegionName) values (1, 'Eastern');
insert into Regions JSON '{"RegionID":2, "RegionName":"Western"}';
insert into Regions (RegionID, RegionName) values (3, 'Northern') if not exists;
insert into Regions JSON '{"RegionID":4, "RegionName":"Southern"}' if not exists;




create table Products(
ProductID int primary key,
ProductName text,
SupplierID int,
CategoryID int,
QuantityPerUnit text,
UnitPrice float,
UnitsInStock int,
UnitsOnOrder int,
ReorderLevel int,
Discontinued boolean);

create type OrderLineItem(ProductID int, Quantity int, UnitPrice float);

CREATE TABLE orders (
    orderid int PRIMARY KEY,
    customerid int,
    lineitems set<frozen<orderlineitem>>,
    orderdate date
);


insert into orders (orderid, orderdate, customerid, lineitems) values (2, '2017-07-11', 100,{ {productid:9, unitprice:9.99, quantity:11}, {productid:11, unitprice:12.99, quantity:9} } );

