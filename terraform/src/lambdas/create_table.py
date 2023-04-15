"""Reads messages from SQS buffer and writes data from them to MySQL RDS"""

import boto3
import json
import os
import pymysql.cursors
# import pymysql


db_host = "my-sql-demo-db.cbppkiwouxgk.eu-west-1.rds.amazonaws.com"
db_user = "admin"
mysql_port = 3306
db_pass = "0CAD2FB5D9"
db_name = "mydb"


# Connect to MySQL RDS
connection = pymysql.connect(host=db_host, port=mysql_port,
                           user=db_user, password=db_pass,
                           database=db_name,
                           cursorclass=pymysql.cursors.DictCursor)

with connection:
    # with connection.cursor() as cursor:
    #     # Create a new record
    #     sql = "CREATE SCHEMA `superheroes`;"
    #     cursor.execute(sql)

    # # connection is not autocommit by default. So you must commit to save
    # # your changes.
    # connection.commit()

    with connection.cursor() as cursor:
        # Create a new record
        sql = """
            DROP TABLE IF EXISTS mydb.hero_attribute;

            CREATE TABLE mydb.hero_attribute (
            hero_id INT DEFAULT NULL,
            attribute_id INT DEFAULT NULL,
            attribute_value INT DEFAULT NULL
            );

            INSERT INTO mydb.hero_attribute (hero_id, attribute_id, attribute_value) VALUES
            (8,1,85),
            (11,1,60),
            (12,1,90),
            (21,1,85),
            (743,2,90),
            (744,2,100),
            (745,2,100),
            (1,3,45),
            (2,3,20),
            (3,3,35),
            (19,4,45),
            (21,4,85),
            (122,5,30),
            (123,5,25),
            (126,5,65),
            (272,6,100),
            (310,6,45);

            COMMIT;
        """
        # sql = "CREATE TABLE test_table (Name varchar(255), ID int);"
        cursor.execute(sql)

    # connection is not autocommit by default. So you must commit to save
    # your changes.
    connection.commit()