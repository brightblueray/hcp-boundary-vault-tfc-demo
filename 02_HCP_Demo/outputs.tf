#
# Outputs
#

output "aws_region" {
  value = var.aws_region
}

# output "rds_hostname" {
#   description = "RDS instance hostname"
#   value       = aws_db_instance.northwind.address
#   sensitive   = false
# }

# output "rds_port" {
#   description = "RDS instance port"
#   value       = aws_db_instance.northwind.port
#   sensitive   = false
# }

# output "rds_username" {
#   description = "RDS instance root username"
#   value       = aws_db_instance.northwind.username
#   sensitive   = false
# }

# output "vault_addr" {
#   description = "Vault Instance Address"
#   value       = var.vault_addr
# }

# output "boundary_token" {
#   description = "Boundary Token"
#   value       = vault_token.boundary.client_token
#   sensitive   = true
# }