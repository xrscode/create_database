import pg8000
import boto3
import json


# Get address of database endpoint:
def get_endpoint():
    client = boto3.client('ssm')
    response = client.get_parameter(
        Name='db_endpoint'
    )
    return response['Parameter']['Value']


# Get database password:
def get_password():
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId='psql')
    return response['SecretString']


# Assign Database Credentials:
db_user = 'postgres'
db_host = get_endpoint()[0:-5]
db_port = 5432
db_password = get_password()


credentials = {'host': db_host,
               'password': db_password,
               'user': db_user,
               'port': db_port
               }

# Load DB Instructions
with open('data/create_totesys.sql') as file:
    sql = file.read()

# Load DB JSON
with open('data/dbdata.json') as file:
    data = json.loads(file.read())


# Create database schema:
def create_database():
    con = pg8000.connect(**credentials)
    f"""This function will create a PSQL databse."""
    queries = sql.split('; ')
    for query in queries:
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
    con = pg8000.connect(**credentials)
    f"""This function will add data to a PSQL database."""
    cursor = con.cursor()
    for table in data:
        # Iterate through Dictionary.
        # Each Key is a table Name.
        print(f"Adding data to {table}")
        # Extract column names:
        column_names = [x for x in data[table][0]]
        column_names_string = ', '.join(column_names)
        placeholder = ', '.join('%s' for _ in range(len(column_names)))
        values = [list(row.values()) for row in data[table]]
        query = f"INSERT INTO {
            table} ({column_names_string}) VALUES ({placeholder});"
        cursor.executemany(query, values)
        con.commit()
    con.close()
    print('Connection closed.')
    pass


# Call functions
create_database()
add_data()
