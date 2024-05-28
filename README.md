# create_database
This project aims to set up an AWS RDS PSQL database called 'totesys'.  

# Requirements
1. Terraform installed and operational. 
2. Logged into the AWS CLI interface with an account that has the necessary permissions to implement infrastructure.

# installation

1.  Clone the repository:
    git clone https://github.com/xrscode/create_database

2. Navigate to project directory.

3. Create environment.  Type into terminal:
    make create-environment

4. Install requirements.  Type into terminal:
    make requirements

5.  Run the project.  Type into terminal:
    make run

# usage
When the project intiates it will prompt the user for a password.
This password is the password that will be set for the database
named 'totesys'.  

After the password has been set the database will be setup. 

# database removal
To remove the database 'totesys' type into the terminal; 

    make remove


