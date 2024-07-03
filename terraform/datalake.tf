# Creates an AWS RDS Database named 'data_lake'. 
resource "aws_db_instance" "data_lake" {
# Name of database:
  identifier             = "datalake"

# Processing power required:
  instance_class         = "db.t3.micro"

# Lowest available storage 5gb:
  allocated_storage      = 5

# Postgres Engine:
  engine                 = "postgres"
  engine_version         = "16.2"

# User Credentials:
  username               = "postgres"
  password               = data.aws_secretsmanager_secret_version.psql_password.secret_string

# Set incoming/outgoing connections to allow:
  vpc_security_group_ids = [aws_security_group.postgres_allow.id]

# Allow connections from web:
  publicly_accessible    = true
  
# Allow Database to be deleted instantly:
  skip_final_snapshot    = true

# Ensure Enhanced Monitoring is turned off
  monitoring_interval    = 0

# Assign Parameter Group
  parameter_group_name = aws_db_parameter_group.totesys.name

# Set Availability Zone:
  availability_zone = "eu-west-2a" 

depends_on = [ data.aws_secretsmanager_secret_version.psql_password ]
}


# Store DB Endpoint in AWS Parameter Store
resource "aws_ssm_parameter" "db_endpoint_dl" {
  name        = "db_endpoint_dl"
  description = "The endpoint of the RDS instance"
  type        = "String"
  value       = aws_db_instance.data_lake.endpoint
}
