#! /bin/sh
mongoimport -d northwind -c "categories" --type "csv" --file "/examples/northwind/CSVHeaders/categories/categories.csv" --headerline
mongoimport -d northwind -c "customers" --type "csv" --file "/examples/northwind/CSVHeaders/customers/customers.csv" --headerline
mongoimport -d northwind -c "employees" --type "csv" --file "/examples/northwind/CSVHeaders/employees/employees.csv" --headerline
mongoimport -d northwind -c "employeeterritories" --type "csv" --file "/examples/northwind/CSVHeaders/employeeterritories/employeeterritories.csv" --headerline
mongoimport -d northwind -c "orderdetails" --type "csv" --file "/examples/northwind/CSVHeaders/orderdetails/orderdetails.csv" --headerline
mongoimport -d northwind -c "orders" --type "csv" --file "/examples/northwind/CSVHeaders/orders/orders.csv" --headerline
mongoimport -d northwind -c "products" --type "csv" --file "/examples/northwind/CSVHeaders/products/products.csv" --headerline
mongoimport -d northwind -c "regions" --type "csv" --file "/examples/northwind/CSVHeaders/regions/regions.csv" --headerline
mongoimport -d northwind -c "shippers" --type "csv" --file "/examples/northwind/CSVHeaders/shippers/shippers.csv" --headerline
mongoimport -d northwind -c "suppliers" --type "csv" --file "/examples/northwind/CSVHeaders/suppliers/suppliers.csv" --headerline
mongoimport -d northwind -c "territories" --type "csv" --file "/examples/northwind/CSVHeaders/territories/territories.csv" --headerline
mongoimport -d northwind -c "usstates" --type "csv" --file "/examples/northwind/CSVHeaders/usstates/usstates.csv" --headerline
