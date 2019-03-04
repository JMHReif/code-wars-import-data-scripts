LOAD CSV WITH HEADERS FROM "file:///customers.csv" AS row
WITH row.CustomerID AS id, row.CompanyName AS name, row.ContactName AS contactName, row.ContactTitle AS title, row.Address AS address, row.City AS city, row.Region AS region, row.PostalCode AS postalCode, row.Country AS custCountry, row.Phone AS phone, row.Fax AS fax
MERGE (customer:Person:Customer {customerId: id})
ON CREATE SET customer.companyName = name,
              customer.address = address,
              customer.city = city,
              customer.region = region,
              customer.postalCode = postalCode,
              customer.phone = phone,
              customer.fax = fax
WITH customer, custCountry, contactName, title
MERGE (country:Country {name: custCountry})
MERGE (customer)-[:LOCATED_IN]->(country)
WITH customer, contactName, title
MERGE (contact:Person:Contact {contactName: contactName})
ON CREATE SET contact.contactTitle = title
MERGE (customer)-[:HAS_CONTACT]->(contact)
RETURN count(customer);

LOAD CSV WITH HEADERS FROM "file:///employees.csv" AS row
WITH toInteger(row.EmployeeID) AS id, row.LastName AS lName, row.FirstName AS fName, row.Title AS title, row.TitleOfCourtesy AS titleOfCourtesy, row.BirthDate AS birthdate, row.HireDate AS hiredate, row.Address AS address, row.City AS city, row.Region AS region, row.PostalCode AS postalCode, row.Country AS emplCountry, row.HomePhone as phone, toInteger(row.Extension) AS extension, row.Photo AS photo, row.Notes AS notes, toInteger(row.ReportsTo) as mgrId, row.PhotoPath as photoPath
MERGE (employee:Person:Employee {employeeId: id})
 SET employee.lastName = lName,
     employee.firstName = fName,
     employee.title = title,
     employee.titleOfCourtesy = titleOfCourtesy,
     employee.birthDate = birthdate,
     employee.hireDate = hiredate,
     employee.address = address,
     employee.city = city,
     employee.region = region,
     employee.postalCode = postalCode,
     employee.homePhone = phone,
     employee.extension = extension,
     employee.photo = photo,
     employee.notes = notes,
     employee.photoPath = photoPath
MERGE (country:Country {name: emplCountry})
MERGE (employee)-[:LOCATED_IN]->(country)
WITH employee, mgrId WHERE mgrId IS NOT NULL
MERGE (manager:Person:Employee {employeeId: mgrId})
MERGE (employee)-[:REPORTS_TO]->(manager)
RETURN count(employee);

LOAD CSV WITH HEADERS FROM "file:///products.csv" AS row
WITH toInteger(row.ProductID) AS id, row.ProductName AS name, row.QuantityPerUnit AS quantityPerUnit, toFloat(row.UnitPrice) AS unitPrice, toInteger(row.UnitsInStock) AS unitsInStock, toInteger(row.UnitsOnOrder) AS unitsOnOrder, toInteger(row.ReorderLevel) AS reorderLevel, toInteger(row.Discontinued) AS discontinued
MERGE (product:Product {productId: id})
ON CREATE SET product.productName = name,
              product.quantityPerUnit = quantityPerUnit,
              product.unitPrice = unitPrice,
              product.unitsInStock = unitsInStock,
              product.unitsOnOrder = unitsOnOrder,
              product.reorderLevel = reorderLevel,
              product.discontinued = discontinued
RETURN count(product);

LOAD CSV WITH HEADERS FROM "file:///orders.csv" AS row
WITH toInteger(row.OrderID) AS id, row.CustomerID AS customerId, toInteger(row.EmployeeID) AS employeeId, row.OrderDate AS orderDate, row.RequiredDate AS requiredDate, row.ShippedDate AS shipDate, toInteger(row.ShipVia) AS shipVia, toFloat(row.Freight) AS freight, row.ShipName AS name, row.ShipAddress AS address, row.ShipCity AS city, row.ShipRegion AS region, row.ShipPostalCode AS postalCode, row.ShipCountry AS shipCountry, toInteger(row.ProductID) AS productId, toFloat(row.UnitPrice) AS unitPrice, toInteger(row.Quantity) AS quantity, toFloat(row.Discount) AS discount
MERGE (order:Order {orderId: id})
ON CREATE SET order.orderDate = orderDate,
              order.requiredDate = requiredDate,
              order.shippedDate = shipDate,
              order.shipVia = shipVia,
              order.freight = freight,
              order.shipName = name,
              order.shipAddress = address,
              order.shipCity = city,
              order.shipRegion = region,
              order.shipPostalCode = postalCode
MERGE (customer:Customer {customerId: customerId})
MERGE (order)-[:CREATED_BY]->(customer)
WITH order, employeeId, shipCountry, productId, unitPrice, quantity, discount
MERGE (employee:Employee {employeeId: employeeId})
MERGE (order)-[:MANAGED_BY]->(employee)
WITH order, shipCountry, productId, unitPrice, quantity, discount
MERGE (country:Country {name: shipCountry})
MERGE (order)-[:SHIPPED_TO]->(country)
WITH order, productId, unitPrice, quantity, discount
MERGE (product:Product {productId: productId})
MERGE (order)-[rel:INCLUDES]->(product)
 SET rel.unitPrice = unitPrice,
     rel.quantity = quantity,
     rel.discount = discount
RETURN count(order);
