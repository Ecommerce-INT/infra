################################################################################
# Outputs – Prod Environment
################################################################################

# --------------------------------------------------------------------------
# Networking
# --------------------------------------------------------------------------

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.networking.vpc_cidr_block
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.networking.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.networking.private_subnets
}

output "database_subnets" {
  description = "Database subnet IDs"
  value       = module.networking.database_subnets
}

output "nat_public_ips" {
  description = "NAT Gateway public IPs"
  value       = module.networking.nat_public_ips
}

# --------------------------------------------------------------------------
# EKS
# --------------------------------------------------------------------------

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority" {
  description = "Base64-encoded EKS cluster CA certificate"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "eks_oidc_provider_arn" {
  description = "EKS OIDC provider ARN for IRSA"
  value       = module.eks.oidc_provider_arn
}

# --------------------------------------------------------------------------
# RDS
# --------------------------------------------------------------------------

output "rds_endpoint" {
  description = "RDS PostgreSQL connection endpoint"
  value       = module.rds.db_instance_endpoint
}

output "rds_address" {
  description = "RDS PostgreSQL hostname"
  value       = module.rds.db_instance_address
}

output "rds_master_secret_arn" {
  description = "ARN of the Secrets Manager secret for RDS master password"
  value       = module.rds.db_master_user_secret_arn
}

# --------------------------------------------------------------------------
# SQS
# --------------------------------------------------------------------------

output "sqs_queue_url" {
  description = "SQS main queue URL"
  value       = module.sqs.queue_url
}

output "sqs_queue_arn" {
  description = "SQS main queue ARN"
  value       = module.sqs.queue_arn
}

output "sqs_dlq_url" {
  description = "SQS dead-letter queue URL"
  value       = module.sqs.dlq_url
}

# --------------------------------------------------------------------------
# ECR
# --------------------------------------------------------------------------

output "ecr_repository_urls" {
  description = "Map of ECR repository names to URLs"
  value       = module.ecr.repository_urls
}

# --------------------------------------------------------------------------
# Workload IAM (IRSA)
# --------------------------------------------------------------------------

output "eso_irsa_role_arn" {
  description = "IRSA role ARN for External Secrets Operator"
  value       = module.workload_iam.eso_irsa_role_arn
}

output "order_service_irsa_role_arn" {
  description = "IRSA role ARN for Order Service"
  value       = module.workload_iam.order_service_irsa_role_arn
}

output "notification_worker_irsa_role_arn" {
  description = "IRSA role ARN for Notification Worker"
  value       = module.workload_iam.notification_worker_irsa_role_arn
}
