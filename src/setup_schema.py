import pg8000
import boto3
import os
from dotenv import load_dotenv

# Get address of Database endpoint:


def get_endpoint():
    client = boto3.client('ssm')
    response = client.get_parameter(
        Name='db_endpoint'
    )
    return response['Parameter']['Value']


# Assign Database Credentials:
# db_host = get_endpoint()
# db_user = os.getenv('DB_USER')
# db_password = os.getenv('DB_PASSWORD')
# db_name = os.getenv('DB_NAME')
# db_port = os.getenv('DB_PORT')

# print(db_host)
# totesys.cfk2gikqsjhw.eu-west-2.rds.amazonaws.com


credentials = {'host': 'totesys.cfk2gikqsjhw.eu-west-2.rds.amazonaws.com',
               'database': 'totesys',
               'password': 'password',
               'user': 'postgres',
               'port': 5432}

try:
    print('...attempting to connect')
    con = pg8000.connect(**credentials)
    print('Connected to the database!')
    con.close()
except Exception as e:
    print(e)
