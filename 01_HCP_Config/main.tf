# Terraform Config
terraform {
  required_providers {
    hcp = {
      source = "hashicorp/hcp"
    }
  }

  cloud {
    organization = "brightblueray"
    workspaces {
      name = "hcp-demo-config"
    }
  }
}

variable "boundary_password" {sensitive = true}

##
## HCP 
##
provider "hcp" {
  # Auth uses TFC Variable Set
}

module "hcp_demo" {
  source = "./modules/hcp_demo"

  # HVN 
  hvn_id = "demo-hvn"
  hvn_cidr = "172.25.16.0/20"
  aws_region = "us-east-2"

  # VAULT CLUSTER
  vault_cluster_id = "hcp-vault-demo"
  vault_cluster_tier = "dev"

  # BOUNDARY CLUSTER
  boundary_cluster_id = "hcp-boundary-demo"
  boundary_user = "rryjewski"
  boundary_password = var.boundary_password
}


## Outputs
output "vault_token" {
  value = module.hcp_demo.vault_token
  sensitive = true
}

output "vault_addr" {
  value = module.hcp_demo.vault_addr
  sensitive = false
}

output "boundary_addr" {
  value = module.hcp_demo.boundary_addr
  sensitive = false
}

output "boundary_user" {
  value = module.hcp_demo.boundary_user
}

output "boundary_password" {
  value = module.hcp_demo.boundary_password
  sensitive = true
}
  