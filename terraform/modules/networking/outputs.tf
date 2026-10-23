###############################################################################
# Networking Module – Outputs
###############################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "database_subnet_group_name" {
  description = "Name of the database subnet group"
  value       = module.vpc.database_subnet_group_name
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.vpc.private_route_table_ids
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for NAT Gateways"
  value       = module.vpc.nat_public_ips
}

output "azs" {
  description = "List of availability zones used"
  value       = module.vpc.azs
}

output "default_security_group_id" {
  description = "The ID of the default security group (locked down)"
  value       = module.vpc.default_security_group_id
}

output "s3_endpoint_id" {
  description = "The ID of the S3 Gateway VPC Endpoint"
  value       = aws_vpc_endpoint.s3.id
}
