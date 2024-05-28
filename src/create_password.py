# Establish password for AWS RDS PSQL database.
# Store password in AWS Secrets Manager.
import boto3
from botocore.exceptions import ClientError
import json


# Prompt user for password to be used with AWS RDS PSQL database
while True:
    client = boto3.client('secretsmanager')
    user_input_one = input(
        "Please enter a database password.  Password must be alphanumeric only.")
    user_input_two = input("Please re-enter the database password.")
    if user_input_one == user_input_two:
        print('Passwords match.')
        if user_input_one.isalnum() and len(
                user_input_one) > 7 and len(user_input_one) < 21:
            print('Password is valid.')
            try:
                # Check if secret Exists.
                response = client.describe_secret(SecretId='psql')
                if response['ResponseMetadata']['HTTPStatusCode'] == 200:
                    print(f"'{response['Name']}' exists.  Updating now...")
                    # If secret already exists, update secret:
                    try:
                        response = client.update_secret(
                            SecretId='psql', SecretString=user_input_one)
                        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
                            print('Secret successfully updated!')
                            break
                    except Exception as e:
                        print('Unable to update secret: ', e)
                else:
                    print('Secret does not exist.  Creating secret now...')
                    # If secret does not exist create secret:
                    try:
                        response = client.create_secret(
                            Name='psql', SecretString=user_input_one)
                        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
                            print('Secret successfully stored in AWS.')
                            break
                    except Exception as e:
                        print(e)
            except Exception as e:
                print(e)
        else:
            print(
                'Password must be alphanumeric only and be between 8 and 20 characters in length.')
    else:
        print('Passwords do not match please try again.')
