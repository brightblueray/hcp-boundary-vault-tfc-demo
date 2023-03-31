#
# Variables
#

## AWS ##
variable "aws_region" {
  type        = string
  description = "(required) The AWS region to use"
  default     = "us-east-2"
}


# ## BOUNDARY ##
# variable "boundary_addr" {
#   default = "https://2bf6ece9-7af1-4596-8770-2fc653fc3068.boundary.hashicorp.cloud"
# }

# variable "boundary_user" {
#   default = "rryjewski"
# }

# variable "boundary_pw" {}


## POSTGRES ##
variable "db_password" {}


## HCP ##
# variable "hvn_id" {
#   type = string
#   description = "HVN"
#   default = "demo-hvn"
# }

# variable "hvn_cidr" {
#   default = "172.25.16.0/20"
# }


## VAULT ##
# variable "vault_cluster_id" {
#   type = string
#   description = "Vault Cluster Id for lookup"
#   default = "demo-vault"
# }

# variable "vault_cluster_tier" {
#   type        = string
#   description = "(Optional) Tier for Vault Cluster created in HCP. Defaults to dev."
#   default     = "dev"
# }

# variable "vault_addr" {
#   type        = string
#   description = "(Required) The URL of the Vault Server"
#   default     = "https://demo-vault-public-vault-611b2e54.b5c74a97.z1.hashicorp.cloud:8200"
# }

variable "vault_namespace" {
  type        = string
  description = "(Required) The Namespace to be used with Vault"
  default     = "admin" # admin is the default namespace with HCP Vault
}

# variable "vault_token" {
#   type        = string
#   description = "(Required) The Namespace to be used with Vault"
# }
