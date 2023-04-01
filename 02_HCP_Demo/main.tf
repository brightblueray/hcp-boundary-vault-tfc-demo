# Terraform Config
terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
    }

    aws = {
      source = "hashicorp/aws"
    }
  }

  cloud {
    organization = "brightblueray"
    workspaces {
      name = "hcp-demo"
    }
  }
}


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



##
## VAULT
##

# Data Source from Config Workspace
data "terraform_remote_state" "hcp-demo-config" {
  backend = "remote"

  config = {
    organization = "brightblueray"
    workspaces = {
      name = "hcp-demo-config"
    }
  }
}




provider "vault" {
  address = data.terraform_remote_state.hcp-demo-config.outputs.vault_addr
  namespace = "admin"
}

# Vault Boundary Controller Policy
resource "vault_policy" "boundary-controller" {
  name   = "boundary-controller-policy"
  policy = file("${path.module}/boundary-controller-policy.hcl")
}

# Vault Northwind Database Policy
resource "vault_policy" "database-northwind" {
  name   = "northwind-database-policy"
  policy = file("${path.module}/northwind-database-policy.hcl")
}

# Enable DB Secrets Engine
resource "vault_database_secrets_mount" "database" {
  path = "database"

  postgresql {
    name           = "northwind"
    username       = "postgres"
    password       = var.db_password
    connection_url = "postgresql://{{username}}:{{password}}@${aws_db_instance.northwind.address}:5432/northwind"
    allowed_roles  = ["dba", "analyst"]
  }
}

# Create DBA Role
resource "vault_database_secret_backend_role" "dba_role" {
  backend             = vault_database_secrets_mount.database.path
  name                = "dba"
  db_name             = vault_database_secrets_mount.database.postgresql[0].name
  creation_statements = [file("${path.module}/dba.sql.hcl")]
  default_ttl         = 180
  max_ttl             = 3600
}

# Create Analyst Role
resource "vault_database_secret_backend_role" "analyst_role" {
  backend             = vault_database_secrets_mount.database.path
  name                = "analyst"
  db_name             = vault_database_secrets_mount.database.postgresql[0].name
  creation_statements = [file("${path.module}/analyst.sql.hcl")]
  default_ttl         = 180
  max_ttl             = 3600
}

# Vault Token for Boudary
resource "vault_token" "boundary" {
  no_default_policy = true
  policies          = ["${vault_policy.boundary-controller.name}", "${vault_policy.database-northwind.name}"]
  no_parent         = true
  period            = "20m"
  renewable         = true
}


##
## Boundary
##

provider "boundary" {
  addr                            = 
  auth_method_id                  = "ampw_vLmPiuaqdK"
  password_auth_method_login_name = var.boundary_user
  password_auth_method_password   = var.boundary_pw
}

# resource "boundary_scope" "db-org" {
#   name = "db-org"
#   description = "DB Demo Org"
#   scope_id = 
# }
