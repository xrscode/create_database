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
#   vpc_security_group_ids = [aws_security_group.rds.id]
#   parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = false
# Allow Database to be deleted instantly:
  skip_final_snapshot    = true
}

# Turns off SSL:
resource "aws_db_parameter_group" "totesys" {
    name = "nossl"
    family = "postgres16"

    parameter{
        name = "rds.force_ssl"
        value = 0
    }
}