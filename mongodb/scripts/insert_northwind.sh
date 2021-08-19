#! /bin/bash
auth="--authenticationDatabase admin --username mongoadmin --password Testing123"
db="northwind"
options="--type=csv --headerline --ignoreBlanks --mode=merge"

mongoimport $auth --db=$db $options --collection=customer --file=customers.csv --upsertFields=customerId

mongoimport $auth --db $db $options --collection=employee --file=employees.csv --upsertFields=employeeId

#update employees with reporting hierarchy
sed 1d employee_reporting.csv | while IFS="," read employeeId reportsTo
do
  #echo "$employeeId | $reportsTo"
  if [ "$reportsTo" != "" ]; then
    mgrId=$(mongo $auth $db --eval 'db.employee.findOne({employeeId:'$reportsTo'},{_id:0,employeeId:1}).employeeId;' --quiet)
    mgrFName=$(mongo $auth $db --eval 'db.employee.findOne({employeeId:'$reportsTo'},{_id:0,firstName:1}).firstName;' --quiet)
    mgrLName=$(mongo $auth $db --eval 'db.employee.findOne({employeeId:'$reportsTo'},{_id:0,lastName:1}).lastName;' --quiet)
    #echo "$employeeId | $mgrId | $mgrFName | $mgrLName"
    mongo $auth $db --eval 'db.employee.update({employeeId:'$employeeId'}, {$set:{ReportsTo:{managerId:'$mgrId',mgrFirstName:"'$mgrFName'",mgrLastName:"'$mgrLName'"}}});' >> employee_reporting.log
  fi
done

mongoimport $auth --db $db $options --collection=product --file=products.csv --upsertFields=productId

mongoimport $auth --db $db $options --collection=order --file=order_info.csv --upsertFields=orderId

sed 1d order_details.csv | while IFS="," read orderId productId unitPrice quantityOrdered discount
do
  #echo "$orderId | $productId | $unitPrice | $quantityOrdered | $discount"
  productName=$(mongo $auth $db --eval 'db.product.findOne({productId:'$productId'},{_id:0,productName:1}).productName;' --quiet)
  mongo $auth $db --eval 'db.order.update({orderId:'$orderId'}, {$addToSet:{Products:{productId:'$productId',productName:"'$productName'",unitPrice:'$unitPrice',quantityOrdered:'$quantityOrdered',discount:'$discount'}}});' >> order_details.log
done

sed 1d order_contacts.csv | while IFS="," read orderId customerId employeeId
do
  #echo "$orderId | $customerId | $employeeId"
  companyName=$(mongo $auth $db --eval 'db.customer.findOne({customerId:"'$customerId'"},{_id:0,companyName:1}).companyName;' --quiet)
  employeeFName=$(mongo $auth $db --eval 'db.employee.findOne({employeeId:'$employeeId'},{_id:0,firstName:1}).firstName;' --quiet)
  employeeLName=$(mongo $auth $db --eval 'db.employee.findOne({employeeId:'$employeeId'},{_id:0,lastName:1}).lastName;' --quiet)
  mongo $auth $db --eval 'db.order.update({orderId:'$orderId'}, {$set:{Customer:{customerId:"'$customerId'",companyName:"'$companyName'"}}});' >> order_contacts.log
  mongo $auth $db --eval 'db.order.update({orderId:'$orderId'}, {$set:{Employee:{employeeId:'$employeeId',firstName:"'$employeeFName'",lastName:"'$employeeLName'"}}});' >> order_contacts.log
done