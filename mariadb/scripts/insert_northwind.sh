#! /bin/bash
#mysqladmin -uroot -pTesting123 create northwind
mysql -uroot -pTesting123 -s < northwind_setup.sql

mysql -uroot -pTesting123 -D northwind <<SQL
 LOAD DATA LOCAL INFILE 'customers.csv' INTO TABLE customers
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;
 SHOW WARNINGS;
SQL

mysql -uroot -pTesting123 -D northwind <<SQL
LOAD DATA LOCAL INFILE 'employees.csv' INTO TABLE employees
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;
SHOW WARNINGS;
SQL

mysql -uroot -pTesting123 -D northwind <<SQL
LOAD DATA LOCAL INFILE 'products.csv' INTO TABLE products
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;
SHOW WARNINGS;
SQL

mysql -uroot -pTesting123 -D northwind <<SQL
LOAD DATA LOCAL INFILE 'order_info.csv' INTO TABLE orders
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;
SHOW WARNINGS;
SQL

mysql -uroot -pTesting123 -D northwind <<SQL
LOAD DATA LOCAL INFILE 'order_details.csv' INTO TABLE orderProducts
 FIELDS TERMINATED BY ','
 OPTIONALLY ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;
SHOW WARNINGS;
SQL