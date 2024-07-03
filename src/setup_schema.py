import pg8000
import boto3
import json


"""
This python script will:

1.  Store database credentials into AWS Secrets Manager.
The credentials will be stored with a SecretId of; 'totesys_cred'.
This will allow ease of access for future projects.

2. Read from SQL file; 'create_totesys.sql' to create the 'totesys' database.

3.  Read form 'dbdata.json' and populate the database with the starting data.  It will not manipulate the data in any way.
"""


# Get address of database endpoint:
def get_endpoint(endpoint):
    # Get Parameter:
    client = boto3.client('ssm')
    response = client.get_parameter(
        Name=endpoint
    )
    return response['Parameter']['Value']


# Get database password:
def get_password():
    # Get Secret:
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId='psql')
    return response['SecretString']


# Assign Database Credentials:
db_user = 'postgres'
db_host = get_endpoint('db_endpoint')[0:-5]
db_port = 5432
db_password = get_password()
db_lake = get_endpoint('db_endpoint_dl')[0:-5]


credentials = {'host': db_host,
               'password': db_password,
               'user': db_user,
               'port': db_port
               }
credentials_data_lake = {'host': db_lake,
                         'password': db_password,
                         'user': db_user,
                         'port': db_port
                         }


# Load database credentials into AWS Secrets Manager:
def store_credentials():
    client = boto3.client('secretsmanager')
    # Check secret exists:
    try:
        # First check if secret exists:
        print('Checking if secret already exists...')
        response = client.describe_secret(SecretId='totesys_cred')
        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            # IF secret exists, UPDATE:
            try:
                print('Secret exists...updating...')
                response = client.update_secret(
                    SecretId='totesys_cred', SecretString=str(credentials))
                if response['ResponseMetadata']['HTTPStatusCode'] == 200:
                    print('Secret succesfully updated!')
                    return 'Secret successfully updated!'
            except Exception as e:
                return e
    except Exception as e:
        # IF Secret does NOT exist create secret:
        print('Secret does not exist.')
        print('Creating secret.')
        response = client.create_secret(
            Name='totesys_cred', SecretString=str(credentials))
        # Check for status code 200.
        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            print('Secret succesfully created.')
            return 'Secret successfully created.'
        else:
            raise
    pass


# Load DB Instructions
with open('data/create_totesys.sql') as file:
    sql = file.read()

# Load DB JSON
with open('data/dbdata.json') as file:
    data = json.loads(file.read())


# Create database schema:
def create_database():
    # Establish connection:
    con = pg8000.connect(**credentials)
    f"""This function will create a PSQL databse."""
    # Read queries from 'create_totesys.sql'
    # Split by '; '
    queries = sql.split('; ')
    for query in queries:
        # For each query, query database to setup schema:
        try:
            con.run(query)
            con.commit()
        except RuntimeError as e:
            print(e)
    print('Database successfully created.')
    con.close()
    print('Connection closed.')


# Load data into database from supplied json:
def add_data():
    # Establish connection
    con = pg8000.connect(**credentials)
    f"""This function will add data to a PSQL database."""
    cursor = con.cursor()
    for table in data:
        # Iterate through Dictionary.
        # Each Key is a table Name.
        print(f"Adding data to {table}")
        # Extract column names:
        column_names = [x for x in data[table][0]]
        # Convert column names to string:
        column_names_string = ', '.join(column_names)
        # Create correct amount of placeholders; %s %s %s...
        placeholder = ', '.join('%s' for _ in range(len(column_names)))
        # Create list of values
        values = [list(row.values()) for row in data[table]]
        # Create query
        query = f"""
        INSERT INTO {table} ({column_names_string})
        VALUES ({placeholder});
        """
        # Use executemany when providing list of values.
        # Aggregates queries to improve performance:
        cursor.executemany(query, values)
        con.commit()
    # Close connection
    con.close()
    print('Connection closed.')
    pass


with open('data/create_data_lake.sql') as file:
    dl = file.read()


def data_lake_schema():
    con = pg8000.connect(**credentials_data_lake)
    queries = dl.split('; ')
    for query in queries:
        # For each query, query database to setup schema:
        try:
            con.run(query)
            con.commit()
        except RuntimeError as e:
            print(e)
    print('Database successfully created.')
    con.close()
    print('Connection closed.')


    # Call functions:
create_database()
add_data()
store_credentials()
data_lake_schema()
