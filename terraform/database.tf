# Creates an AWS RDS Database named 'totesys'. 
# Set The Region:
provider "aws" {
    region = "eu-west-2"
}

# Access AWS Secrets Manager.  Gain PSQL server password:
# Data source to access the secret metadata
data "aws_secretsmanager_secret" "psql" {
  name = "psql"  # Replace with your secret's name
}

# Data source to access the secret value
data "aws_secretsmanager_secret_version" "psql_password" {
  secret_id = data.aws_secretsmanager_secret.psql.id
}

resource "aws_db_instance" "totesys" {
# Name of database:
  identifier             = "totesys"

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

# Turns off SSL:
resource "aws_db_parameter_group" "totesys" {
    name = "nossl"
    family = "postgres16"

    parameter {
        name = "rds.force_ssl"
        value = 0
    }
}

# Store DB Endpoint in AWS Parameter Store
resource "aws_ssm_parameter" "db_endpoint" {
  name        = "db_endpoint"
  description = "The endpoint of the RDS instance"
  type        = "String"
  value       = aws_db_instance.totesys.endpoint
}

# Create Security Group
# Security Group allows connections to PSQL database.
resource "aws_security_group" "postgres_allow" {
  name = "postgres-rules"
  description = "provides inbound/outbound rules"

  # Set Inbound Rules:
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    # Allow connection from any ip:
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Set Outbound Rules:
  egress {
    from_port = 0
    to_port = 0
    # Allow all traffic:
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

