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


insert into orders (orderid, orderdate, customerid, LineItems) values (1, '2017-07-11', 100, { {productid:1, unitprice:19.99} } );
insert into orders (orderid, orderdate, customerid, lineitems) values (2, '2017-07-11', 100, { {productid:9, unitprice:9.99, quantity:11}, {productid:11, unitprice:12.99, quantity:9} } );
insert into orders json '{"orderid": 3, "customerid": 101, "lineitems": [{"productid": 91, "quantity": 11, "unitprice": 9.99}, {"productid": 110, "quantity": 9, "unitprice": 12.99}], "orderdate": "2017-07-11"}';
select * from Orders;

create table Customers (id int primary key, name text, address map<text,text>);
insert into customers (id, name, address) values (1, 'abc',  {'address':'123 main street', 'city':'Springfield', 'state':'VA'});
SELECT * from customers;
update customers set address = address + {'zip':'12345'} where id = 1;
SELECT * from customers;
update customers set address['zip'] = '34566' where id = 1;
SELECT * from customers;
update customers set address['phone'] = '34566' where id = 1;
SELECT * from customers;
update customers set address = address + {'phone':'9999'} where id = 1;
SELECT * from customers;

create index ixOrders_customerID on Orders(customerid);
select * from orders where customerid = 100;
drop index drop index ixorders_customerid
describe tables
