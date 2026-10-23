################################################################################
# RDS Module – Outputs
################################################################################

output "db_instance_endpoint" {
  description = "Connection endpoint for the RDS instance (host:port)"
  value       = module.rds.db_instance_endpoint
}

output "db_instance_address" {
  description = "Hostname of the RDS instance"
  value       = module.rds.db_instance_address
}

output "db_instance_port" {
  description = "Port the RDS instance is listening on"
  value       = module.rds.db_instance_port
}

output "db_instance_name" {
  description = "Name of the initial database created on the RDS instance"
  value       = module.rds.db_instance_name
}

output "db_instance_identifier" {
  description = "Identifier of the RDS instance"
  value       = module.rds.db_instance_identifier
}

output "db_instance_arn" {
  description = "ARN of the RDS instance"
  value       = module.rds.db_instance_arn
}

output "db_master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret containing the master user password"
  value       = module.rds.db_instance_master_user_secret_arn
}

output "db_security_group_id" {
  description = "Security group ID attached to the RDS instance"
  value       = module.rds_security_group.security_group_id
}
