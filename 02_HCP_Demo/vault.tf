##
## VAULT
##

provider "vault" {
  address = data.terraform_remote_state.hcp-demo-config.outputs.vault_addr
  namespace = "admin"
  token = data.terraform_remote_state.hcp-demo-config.outputs.vault_token
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
