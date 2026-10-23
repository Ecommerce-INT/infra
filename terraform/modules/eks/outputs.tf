################################################################################
# EKS Module – Outputs
################################################################################

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint URL for the EKS cluster API server"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate data for the EKS cluster CA"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_version" {
  description = "Kubernetes version running on the EKS cluster"
  value       = module.eks.cluster_version
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for the EKS cluster (used for IRSA)"
  value       = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider for IRSA"
  value       = module.eks.oidc_provider_arn
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Security group ID attached to the EKS managed node groups"
  value       = module.eks.node_security_group_id
}

output "cluster_primary_security_group_id" {
  description = "Primary security group ID of the EKS cluster (auto-created by AWS)"
  value       = module.eks.cluster_primary_security_group_id
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = module.eks.cluster_iam_role_arn
}
