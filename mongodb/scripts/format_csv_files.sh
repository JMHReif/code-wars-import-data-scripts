#/bin/bash

#format employee files
csvcut --columns=1,17 employees.csv > employee_reporting.csv

#format order files
csvcut --columns=1,4,5,6,7,8,9,10,11,12,13,14 orders.csv > order_info.csv
csvcut --columns=1,16,17,18,19 orders.csv > order_details.csv
csvcut --columns=1,2,3 orders.csv > order_contacts.csv
