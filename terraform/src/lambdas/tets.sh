#!/bin/sh

# mysql -u admin -p'0CAD2FB5D9' \
#     -h my-sql-demo-db.cbppkiwouxgk.eu-west-1.rds.amazonaws.com -P 3306 \
#     -D mydb
# CREATE TABLE hero_attribute (hero_id int, attribute_id int, attribute_value int);
# exit

mysql --local-infile=1 \
    -h "my-sql-demo-db.cbppkiwouxgk.eu-west-1.rds.amazonaws.com" \
    -u "admin" \
    -P 3306 \
    -p "0CAD2FB5D9" \
    "mydb" -e "USE mydb; CREATE TABLE hero_attribute (hero_id int, attribute_id int, attribute_value int);"


mysqlimport  --local \
    --compress \
    --user=admin \
    --password=0CAD2FB5D9 \
    --host=my-sql-demo-db.cbppkiwouxgk.eu-west-1.rds.amazonaws.com \
    --fields-terminated-by=',' mydb hero_attribute.part_*
