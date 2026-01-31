# Data source to get available availability zones
data "aws_availability_zones" "available_zones" {
  state = "available"
}

# Parse the JSON secret string from secrets passed as variable
locals {
  secrets = jsondecode(var.secrets_json)
}

# Database subnet group for RDS
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.environment}-${var.project_name}-db-subnet-group"
  description = "Database subnet group for RDS in us-east-1a and us-east-1b"
  subnet_ids = var.database_subnet_ids
  
  tags = {
    Name        = "${var.environment}-${var.project_name}-db-subnet-group"

  }
}

# RDS instance 
resource "aws_db_instance" "db_instance" {
  identifier = "${var.environment}-${var.project_name}-db-instance"
  engine = var.engine
  engine_version = var.engine_version
  username = local.secrets["username"]
  password = local.secrets["password"]
  db_name = local.secrets["dbname"]
  multi_az = var.multi_az_deployment
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type = "gp2"
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  skip_final_snapshot = true
  publicly_accessible = false
  vpc_security_group_ids = [var.db_security_group_id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  tags = {
    Name        = "${var.environment}-${var.project_name}-db-instance"
  }
}