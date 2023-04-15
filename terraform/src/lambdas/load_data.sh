function handler () {
    mysql -u admin -p'0CAD2FB5D9' \
        -h my-sql-demo-db.cbppkiwouxgk.eu-west-1.rds.amazonaws.com -P 3306 \
        -D mydb
    CREATE TABLE hero_attribute (hero_id int, attribute_id int, attribute_value int);
    exit
    
}