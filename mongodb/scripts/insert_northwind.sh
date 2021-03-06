#! /bin/bash

mongoimport --db northwind --collection customer --type csv --headerline --file customers.csv --ignoreBlanks

mongoimport --db northwind --collection employee --type csv --headerline --file employees.csv --ignoreBlanks

#update employees with reporting hierarchy
sed 1d employee_reporting.csv | while IFS="," read employeeId reportsTo
do
  #echo "$employeeId | $reportsTo"
  if [ "${reportsTo}" != "" ]; then
    mgrId=$(mongo northwind --eval 'db.employee.findOne({employeeId:'"$reportsTo"'},{_id:0,employeeId:1}).employeeId;' --quiet)
    mgrFName=$(mongo northwind --eval 'db.employee.findOne({employeeId:'"${reportsTo}"'},{_id:0,firstName:1}).firstName;' --quiet)
    mgrLName=$(mongo northwind --eval 'db.employee.findOne({employeeId:'"${reportsTo}"'},{_id:0,lastName:1}).lastName;' --quiet)
    #echo "$employeeId | $mgrId | $mgrFName | $mgrLName"
    mongo northwind --eval 'db.employee.update({employeeId:'"${employeeId}"'}, {$set:{ReportsTo:{managerId:'"${mgrId}"',mgrFirstName:"'"${mgrFName}"'",mgrLastName:"'"${mgrLName}"'"}}});' >> employee_reporting.log
  fi
done

mongoimport --db northwind --collection product --type csv --headerline --file products.csv --ignoreBlanks

mongoimport --db northwind --collection order --type csv --headerline --file order_info.csv --ignoreBlanks

sed 1d order_details.csv | while IFS="," read orderId productId unitPrice quantityOrdered discount
do
  #echo "$orderId | $productId | $unitPrice | $quantityOrdered | $discount"
  productName=$(mongo northwind --eval 'db.product.findOne({productId:'"$productId"'},{_id:0,productName:1}).productName;' --quiet)
  mongo northwind --eval 'db.order.update({orderId:'"${orderId}"'}, {$addToSet:{Products:{productId:'"${productId}"',productName:"'"${productName}"'",unitPrice:'"${unitPrice}"',quantityOrdered:'"${quantityOrdered}"',discount:'"${discount}"'}}});' >> order_details.log
done

sed 1d order_contacts.csv | while IFS="," read orderId customerId employeeId
do
  #echo "$orderId | $customerId | $employeeId"
  companyName=$(mongo northwind --eval 'db.customer.findOne({customerId:"'"$customerId"'"},{_id:0,companyName:1}).companyName;' --quiet)
  employeeFName=$(mongo northwind --eval 'db.employee.findOne({employeeId:'"$employeeId"'},{_id:0,firstName:1}).firstName;' --quiet)
  employeeLName=$(mongo northwind --eval 'db.employee.findOne({employeeId:'"$employeeId"'},{_id:0,lastName:1}).lastName;' --quiet)
  mongo northwind --eval 'db.order.update({orderId:'"${orderId}"'}, {$set:{Customer:{customerId:"'"${customerId}"'",companyName:"'"${companyName}"'"}}});' >> order_contacts.log
  mongo northwind --eval 'db.order.update({orderId:'"${orderId}"'}, {$set:{Employee:{employeeId:'"${employeeId}"',firstName:"'"${employeeFName}"'",lastName:"'"${employeeLName}"'"}}});' >> order_contacts.log
done
