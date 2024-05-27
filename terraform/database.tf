# Creates an AWS RDS Database named 'totesys'. 

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
  password               = "password"
#   db_subnet_group_name   = aws_db_subnet_group.education.name
  vpc_security_group_ids = [aws_security_group.postgres_allow.id]
#   parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  
# Allow Database to be deleted instantly:
  skip_final_snapshot    = true

# Ensure Enhanced Monitoring is turned off
  monitoring_interval    = 0

# Assign Parameter Group
  parameter_group_name = aws_db_parameter_group.totesys.name

# Set Availability Zone:
  availability_zone = "eu-west-2a" 
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

