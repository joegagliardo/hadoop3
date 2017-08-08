CREATE TABLE categories (
    categoryid smallint,
    categoryname varchar(15),
    description varchar,
    picture binary
);

CREATE TABLE customers (
    customerid varchar(5),
    companyname varchar(40),
    contactname varchar(30),
    contacttitle varchar(30),
    address varchar(60),
    city varchar(15),
    region varchar(15),
    postalcode varchar(10),
    country varchar(15),
    phone varchar(24),
    fax varchar(24)
);

CREATE TABLE employees (
    employeeid smallint,
    lastname varchar(20),
    firstname varchar(10),
    title varchar(30),
    titleofcourtesy varchar(25),
    birthdate date,
    hiredate date,
    address varchar(60),
    city varchar(15),
    region varchar(15),
    postalcode varchar(10),
    country varchar(15),
    homephone varchar(24),
    extension varchar(4),
    photo binary,
    notes varchar,
    reportsto smallint,
    photopath varchar(255)
);

CREATE TABLE employeeterritories (
    employeeid smallint,
    territoryid varchar(20)
);

CREATE TABLE order_details (
    orderid smallint,
    productid smallint,
    unitprice decimal,
    quantity smallint,
    discount decimal
);

CREATE TABLE orders (
    orderid smallint,
    customerid varchar(5),
    employeeid smallint,
    orderdate date,
    requireddate date,
    shippeddate date,
    shipvia smallint,
    freight decimal,
    shipname varchar(40),
    shipaddress varchar(60),
    shipcity varchar(15),
    shipregion varchar(15),
    shippostalcode varchar(10),
    shipcountry varchar(15)
);

CREATE TABLE products (
    productid smallint,
    productname varchar(40),
    supplierid smallint,
    categoryid smallint,
    quantityperunit varchar(20),
    unitprice decimal,
    unitsinstock smallint,
    unitsonorder smallint,
    reorderlevel smallint,
    discontinued int
);

CREATE TABLE regions (
    regionid smallint,
    regiondescription string
);

CREATE TABLE shippers (
    shipperid smallint,
    companyname varchar(40),
    phone varchar(24)
);

CREATE TABLE suppliers (
    supplierid smallint,
    companyname varchar(40),
    contactname varchar(30),
    contacttitle varchar(30),
    address varchar(60),
    city varchar(15),
    region varchar(15),
    postalcode varchar(10),
    country varchar(15),
    phone varchar(24),
    fax varchar(24),
    homepage string
);

CREATE TABLE territories (
    territoryid varchar(20),
    territorydescription string,
    regionid smallint
);

CREATE TABLE usstates (
    stateid smallint,
    statename varchar(100),
    stateabbr varchar(2),
    stateregion varchar(50)
);


