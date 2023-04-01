##
## Boundary
##

provider "boundary" {
  addr                            = data.terraform_remote_state.hcp-demo-config.outputs.boundary_addr
  auth_method_id                  = "ampw_wnuoth3dgh"
  password_auth_method_login_name = data.terraform_remote_state.hcp-demo-config.outputs.boundary_user
  password_auth_method_password   = data.terraform_remote_state.hcp-demo-config.outputs.boundary_password
}

# Create Global Scope
resource "boundary_scope" "global" {
  global_scope = true
  scope_id = "global"
}

resource "boundary_scope" "db-org" {
  name = "db-org"
  description = "DB Demo Org"
  scope_id = boundary_scope.global.id
  auto_create_admin_role = true
  auto_create_default_role = true
}

resource "boundary_scope" "db-project" {
  name = "db-project"
  scope_id = boundary_scope.db-org.id
  auto_create_admin_role = true
}

resource "boundary_host_catalog_static" "db-catalog" {
  name = "db-catalog"
  scope_id = boundary_scope.db-project.id
}

resource "boundary_host_static" "db-host" {
  name = "postgres-host"
  address = aws_db_instance.northwind.address
  host_catalog_id = boundary_host_catalog_static.db-catalog.id
}

resource "boundary_host_set_static" "db-host-set" {
  host_catalog_id = boundary_host_catalog_static.db-catalog.id
  host_ids = [ boundary_host_static.db-host.id ]
}