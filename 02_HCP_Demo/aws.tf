##
## AWS
##

# Configure AWS Provider
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Purpose = "HCP Boundary Demo"
    }
  }
}

# Available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Create Database VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = "database"
  cidr            = "10.0.0.0/16"
  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  enable_vpn_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Create Security Groups
resource "aws_security_group" "rds" {
  name   = "northwind_rds"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Subnet Group
resource "aws_db_subnet_group" "database_sng" {
  name       = "database"
  subnet_ids = module.vpc.public_subnets
}

# Log Connections
resource "aws_db_parameter_group" "northwind" {
  name   = "northwind"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

# # Create PostGreSQL DB
resource "aws_db_instance" "northwind" {
  # allocated_storage      = 10
  snapshot_identifier = "arn:aws:rds:us-east-2:397466897939:snapshot:northwind-snapshot"
  # db_name                = "northwind"
  db_subnet_group_name   = aws_db_subnet_group.database_sng.name
  # engine                 = "postgres"
  # engine_version         = "14.7"
  instance_class         = "db.t3.micro"
  # username               = "postgres"
  # password               = var.db_password
  parameter_group_name   = aws_db_parameter_group.northwind.name
  publicly_accessible    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
}