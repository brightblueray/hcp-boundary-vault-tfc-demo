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