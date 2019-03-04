CREATE DATABASE IF NOT EXISTS northwind;
use northwind;

CREATE TABLE IF NOT EXISTS customers(
   customerId VARCHAR(20) NOT NULL,
   companyName VARCHAR(100) NOT NULL,
   contactName VARCHAR(40) NOT NULL,
   contactTitle VARCHAR(40),
   address VARCHAR(100),
   city VARCHAR(100),
   region VARCHAR(10),
   postalCode VARCHAR(40),
   country VARCHAR(40),
   phone VARCHAR(40),
   fax VARCHAR(40),
   PRIMARY KEY ( customerId )
);

CREATE TABLE IF NOT EXISTS employees(
  employeeId INT NOT NULL,
  lastName VARCHAR(40) NOT NULL,
  firstName VARCHAR(40) NOT NULL,
  title VARCHAR(40),
  titleOfCourtesy VARCHAR(20),
  birthDate DATE,
  hireDate DATE,
  address VARCHAR(100),
  city VARCHAR(100),
  region VARCHAR(10),
  postalCode VARCHAR(40),
  country VARCHAR(40),
  homePhone VARCHAR(40),
  extension INT,
  photo VARCHAR(40),
  notes VARCHAR(300),
  reportsTo INT,
  photoPath VARCHAR(100),
  PRIMARY KEY ( employeeId )
);

CREATE TABLE IF NOT EXISTS products(
  productId INT NOT NULL,
  productName VARCHAR(100) NOT NULL,
  supplierId INT,
  categoryId INT,
  quantityPerUnit VARCHAR(40),
  unitPrice DECIMAL(10,2),
  unitsInStock INT,
  unitsOnOrder INT,
  reorderLevel INT,
  discontinued INT,
  PRIMARY KEY ( productId )
);

CREATE TABLE IF NOT EXISTS orders(
  orderId INT NOT NULL,
  customerId VARCHAR(20) NOT NULL,
  employeeId INT NOT NULL,
  orderDate DATE,
  requiredDate DATE,
  shippedDate DATE DEFAULT NULL,
  shipVia INT,
  freight DECIMAL(10,2),
  shipName VARCHAR(100),
  shipAddress VARCHAR(100),
  shipCity VARCHAR(100),
  shipRegion VARCHAR(40),
  shipPostalCode VARCHAR(40),
  shipCountry VARCHAR(40),
  PRIMARY KEY ( orderId )
);

CREATE TABLE IF NOT EXISTS orderProducts(
  orderId INT NOT NULL,
  productId INT NOT NULL,
  unitPrice DECIMAL(10,2),
  quantity INT,
  discount DECIMAL(10,2),
  PRIMARY KEY ( orderId, productId )
);
