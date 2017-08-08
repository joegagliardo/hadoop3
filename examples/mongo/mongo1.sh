#! /bin/sh
mongoimport -d northwind -c "products" --type "csv" --file "/examples/northwind/CSVHeaders/products/products.csv" --headerline
