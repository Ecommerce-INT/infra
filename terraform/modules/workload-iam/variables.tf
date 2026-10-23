################################################################################
# Workload IAM Module – Input Variables
################################################################################

variable "environment" {
  type        = string
  description = "Environment name (e.g. dev, staging, prod)"
}

variable "project_name" {
  type        = string
  description = "Project name prefix used for resource naming"
}

variable "oidc_provider_arn" {
  type        = string
  description = "ARN of the EKS OIDC provider for IRSA trust relationships"
}

variable "sqs_queue_arn" {
  type        = string
  description = "ARN of the SQS queue used by Order Service and Notification Worker"
}

variable "secrets_arns" {
  type        = list(string)
  default     = ["*"]
  description = "ARNs of Secrets Manager secrets that ESO is allowed to access"
}

variable "kms_key_arns" {
  type        = list(string)
  default     = ["*"]
  description = "ARNs of KMS keys used for encryption/decryption by workloads"
}

variable "app_namespace" {
  type        = string
  default     = "application"
  description = "Kubernetes namespace for application workloads (Order Service, Notification Worker)"
}

variable "eso_namespace" {
  type        = string
  default     = "external-secrets"
  description = "Kubernetes namespace where External Secrets Operator is deployed"
}

variable "eso_service_account" {
  type        = string
  default     = "external-secrets-sa"
  description = "Kubernetes service account name for External Secrets Operator"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to apply to all resources"
}
