##
## HVN
##

variable "hvn_id" {}
variable "aws_region" {}
variable "hvn_cidr" {}

resource "hcp_hvn" "hvn" {
  hvn_id         = var.hvn_id
  cloud_provider = "aws"
  region         = var.aws_region
  cidr_block     = var.hvn_cidr
}

output "hvn_id" {
  value = hcp_hvn.hvn.id
}


##
## VAULT
##

# Vars
variable "vault_cluster_id" {}
variable "vault_cluster_tier" {}

# Create Vault Cluster -  A Small Demo Cluster ($0.03/hr or about $20/month)
resource "hcp_vault_cluster" "demo_cluster" {
  cluster_id        = var.vault_cluster_id
  hvn_id            = hcp_hvn.hvn.hvn_id
  tier              = var.vault_cluster_tier
  # min_vault_version = var.min_vault_version
  public_endpoint   = true
}

# Get an Admin Token
resource "hcp_vault_cluster_admin_token" "demo" {
  cluster_id = hcp_vault_cluster.demo_cluster.cluster_id
}

# Outputs
output "vault_addr" {
  description = "Vault Instance Address"
  value       = hcp_vault_cluster.demo_cluster.vault_public_endpoint_url
}

output "vault_token" {
  value = hcp_vault_cluster_admin_token.demo.token
  sensitive = true
}



##
## BOUNDARY
##

variable "boundary_cluster_id" {}
variable "boundary_user" {}
variable "boundary_password" {sensitive = true}

# Create Boundary Cluster
resource "hcp_boundary_cluster" "demo_cluster" {
  cluster_id = var.boundary_cluster_id
  username   = var.boundary_user
  password   = var.boundary_password
}

# Outputs
output "boundary_addr" {
  description = "Boundary Instance Address"
  value       = hcp_boundary_cluster.demo_cluster.cluster_url
}

output "boundary_user" {
  description = "Boundary user "
  value       = var.boundary_user
}

output "boundary_password" {
  value = var.boundary_password
  sensitive = true
}




