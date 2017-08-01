#! /bin/sh
mongoimport -d northwind -c "products" --type "csv" --file "/examples/northwind/CSV_Headers/products.csv" --headerline
