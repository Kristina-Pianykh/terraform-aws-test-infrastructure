"""Reads messages from SQS buffer and writes data from them to MySQL RDS"""

import boto3
import json
import os
import pymysql

# Set up SQS client and queue URL
sqs = boto3.client('sqs')
# queue_url = os.getenv('YOUR_SQS_QUEUE_URL')
queue_url="https://sqs.eu-west-1.amazonaws.com/750819603741/DBBuffer.fifo"

# Set up RDS connection
# db_host = os.getenv('YOUR_RDS_HOST')
# db_user = os.getenv('YOUR_RDS_USER')
# db_pass = os.getenv('YOUR_RDS_PASSWORD')
# db_name = os.getenv('YOUR_RDS_DATABASE')
# db_table = os.getenv('YOUR_RDS_TABLE')
# mysql_port = 3306
aws_access_key_id = os.getenv('AWS_ACCESS_KEY_ID')
aws_secret_access_key = os.getenv('AWS_SECRET_ACCESS_KEY')
aws_region = os.getenv('AWS_REGION')
db_host = "my-sql-demo-db.cbppkiwouxgk.eu-west-1.rds.amazonaws.com"
db_user = "admin"
mysql_port = 3306
db_pass = "0CAD2FB5D9"
db_name = "mydb"
db_table = os.getenv('YOUR_RDS_TABLE')

def lambda_handler(event, context):
    # Connect to AWS SQS
    sqs = boto3.client('sqs', aws_access_key_id=aws_access_key_id,
                       aws_secret_access_key=aws_secret_access_key,
                       region_name=aws_region)

    # Connect to MySQL RDS
    conn = pymysql.connect(host=db_host, port=mysql_port,
                           user=db_user, password=db_pass,
                           database=db_name)

    # Loop through messages in SQS queue
    while True:
        response = sqs.receive_message(
            QueueUrl=queue_url,
            MaxNumberOfMessages=1,
            WaitTimeSeconds=20
        )

        # Check if there are messages in the response
        if 'Messages' not in response:
            break

        # Process each message
        for message in response['Messages']:
            # Extract message body
            message_body = message['Body']

            # Write message to MySQL
            with conn.cursor() as cursor:
                sql = 'INSERT INTO messages (message_body) VALUES (%s)'
                cursor.execute(sql, (message_body,))
                conn.commit()

            # Delete message from SQS
            sqs.delete_message(
                QueueUrl=queue_url,
                ReceiptHandle=message['ReceiptHandle']
            )

    # Close MySQL connection
    conn.close()
