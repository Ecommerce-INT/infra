################################################################################
# Workload IAM Module – Outputs
################################################################################

output "eso_irsa_role_arn" {
  description = "IAM role ARN for the External Secrets Operator service account"
  value       = module.eso_irsa.iam_role_arn
}

output "eso_irsa_role_name" {
  description = "IAM role name for the External Secrets Operator service account"
  value       = module.eso_irsa.iam_role_name
}

output "order_service_irsa_role_arn" {
  description = "IAM role ARN for the Order Service service account"
  value       = module.order_service_irsa.iam_role_arn
}

output "order_service_irsa_role_name" {
  description = "IAM role name for the Order Service service account"
  value       = module.order_service_irsa.iam_role_name
}

output "notification_worker_irsa_role_arn" {
  description = "IAM role ARN for the Notification Worker service account"
  value       = module.notification_worker_irsa.iam_role_arn
}

output "notification_worker_irsa_role_name" {
  description = "IAM role name for the Notification Worker service account"
  value       = module.notification_worker_irsa.iam_role_name
}
