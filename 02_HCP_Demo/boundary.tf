##
## Boundary
##
locals {
  boundary_auth_id = "ampw_wnuoth3dgh"
}

provider "boundary" {
  addr                            = data.terraform_remote_state.hcp-demo-config.outputs.boundary_addr
  auth_method_id                  = local.boundary_auth_id
  password_auth_method_login_name = data.terraform_remote_state.hcp-demo-config.outputs.boundary_user
  password_auth_method_password   = data.terraform_remote_state.hcp-demo-config.outputs.boundary_password
}

# # Create Global Scope
# resource "boundary_scope" "global" {
#   global_scope = true
#   scope_id = "global"
# }

# # Create Org under Global
# resource "boundary_scope" "db-org" {
#   name = "db-org"
#   description = "DB Demo Org"
#   scope_id = boundary_scope.global.id
#   auto_create_admin_role = true
#   auto_create_default_role = true
# }

# # Create Project under Org
# resource "boundary_scope" "db-project" {
#   name = "db-project"
#   scope_id = boundary_scope.db-org.id
#   auto_create_admin_role = true
# }

# # Create Host Catalog in Project
# resource "boundary_host_catalog_static" "db-catalog" {
#   name = "db-catalog"
#   scope_id = boundary_scope.db-project.id
# }

# # Create Host and Host Set in Project
# resource "boundary_host_static" "db-host" {
#   name = "postgres-host"
#   address = aws_db_instance.northwind.address
#   host_catalog_id = boundary_host_catalog_static.db-catalog.id
# }

# resource "boundary_host_set_static" "db-host-set" {
#   host_catalog_id = boundary_host_catalog_static.db-catalog.id
#   host_ids = [ boundary_host_static.db-host.id ]
# }

# # Create Targets for DBA and Analyst
# resource "boundary_target" "dba-target" {
#   name = "Northwind DBA Target (TCP)"
#   scope_id = boundary_scope.db-project.id
#   type = "tcp"
#   session_max_seconds = 28800
#   session_connection_limit = -1
#   default_port = 5432
#   host_source_ids = [boundary_host_set_static.db-host-set.id]
#   brokered_credential_source_ids = [ boundary_credential_library_vault.dba.id ]
# }

# resource "boundary_target" "analyst-target" {
#   name = "Northwind Analyst Target (TCP)"
#   scope_id = boundary_scope.db-project.id
#   type = "tcp"
#   session_max_seconds = 28800
#   session_connection_limit = -1
#   default_port = 5432
#   host_source_ids = [boundary_host_set_static.db-host-set.id]
#   brokered_credential_source_ids = [ boundary_credential_library_vault.analyst.id ]
# }

# # Vault Token for Boudary
# resource "vault_token" "boundary" {
#   no_default_policy = true
#   policies          = ["${vault_policy.boundary-controller.name}", "${vault_policy.database-northwind.name}"]
#   no_parent         = true
#   period            = "20m"
#   renewable         = true
# }

# # Create an HCP Vault Credential Store
# resource "boundary_credential_store_vault" "dynamic-cred-store" {
#   name = "HCP Vault Credential Store"
#   address = data.terraform_remote_state.hcp-demo-config.outputs.vault_addr
#   token = vault_token.boundary.client_token
#   scope_id = boundary_scope.db-project.id
#   namespace = "admin"
# }

# # Create Credential Library for DBA 
# resource "boundary_credential_library_vault" "dba" {
#   name = "DBA Dynamic Credentials"
#   credential_store_id = boundary_credential_store_vault.dynamic-cred-store.id
#   http_method = "GET"
#   path = "database/creds/dba"
# }

# # Create Credential Library for Analyst
# resource "boundary_credential_library_vault" "analyst" {
#   name = "Analyst Dynamic Credentials"
#   credential_store_id = boundary_credential_store_vault.dynamic-cred-store.id
#   http_method = "GET"
#   path = "database/creds/analyst"
# }

# boundary connect postgres -target-id ttcp_FtQyzmgD7E -username postgres