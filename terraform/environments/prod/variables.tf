################################################################################
# Variables – Shared across all environments
# Values are provided per-environment in terraform.tfvars
################################################################################

# --------------------------------------------------------------------------
# General
# --------------------------------------------------------------------------

variable "aws_region" {
  type        = string
  description = "AWS region for all resources"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "project_name" {
  type        = string
  description = "Project name used as prefix for all resources"
}

# --------------------------------------------------------------------------
# Networking
# --------------------------------------------------------------------------

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private (application) subnets"
}

variable "database_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for database subnets"
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use a single NAT Gateway (cost saving for non-prod)"
}

variable "one_nat_gateway_per_az" {
  type        = bool
  description = "Create one NAT Gateway per AZ (HA for prod)"
}

# --------------------------------------------------------------------------
# EKS
# --------------------------------------------------------------------------

variable "cluster_version" {
  type        = string
  default     = "1.31"
  description = "Kubernetes version for the EKS cluster"
}

variable "cluster_endpoint_public_access" {
  type        = bool
  default     = true
  description = "Whether the EKS API server endpoint is publicly accessible"
}

variable "node_instance_types" {
  type        = list(string)
  description = "EC2 instance types for the EKS managed node group"
}

variable "node_capacity_type" {
  type        = string
  description = "Capacity type: SPOT or ON_DEMAND"
}

variable "node_min_size" {
  type        = number
  description = "Minimum number of nodes in the managed node group"
}

variable "node_desired_size" {
  type        = number
  description = "Desired number of nodes in the managed node group"
}

variable "node_max_size" {
  type        = number
  description = "Maximum number of nodes in the managed node group"
}

variable "node_disk_size" {
  type        = number
  default     = 50
  description = "Root EBS volume size in GiB for worker nodes"
}

# --------------------------------------------------------------------------
# RDS
# --------------------------------------------------------------------------

variable "rds_instance_class" {
  type        = string
  description = "RDS instance class (e.g. db.t4g.micro, db.r6g.large)"
}

variable "rds_multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment for RDS"
}

variable "rds_allocated_storage" {
  type        = number
  default     = 20
  description = "Initial allocated storage in GiB"
}

variable "rds_max_allocated_storage" {
  type        = number
  default     = 100
  description = "Maximum storage threshold in GiB for autoscaling"
}

variable "rds_backup_retention_period" {
  type        = number
  description = "Number of days to retain automated backups"
}

variable "rds_deletion_protection" {
  type        = bool
  description = "Enable deletion protection on the RDS instance"
}

variable "rds_skip_final_snapshot" {
  type        = bool
  default     = true
  description = "Whether to skip the final DB snapshot on deletion"
}

# --------------------------------------------------------------------------
# ECR
# --------------------------------------------------------------------------

variable "ecr_image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
  description = "Tag mutability setting (MUTABLE or IMMUTABLE)"
}

variable "ecr_force_delete" {
  type        = bool
  default     = false
  description = "Force-delete ECR repositories on destroy"
}

# --------------------------------------------------------------------------
# SQS
# --------------------------------------------------------------------------

variable "sqs_visibility_timeout" {
  type        = number
  default     = 30
  description = "Visibility timeout in seconds"
}

variable "sqs_max_receive_count" {
  type        = number
  default     = 3
  description = "Number of receive attempts before message goes to DLQ"
}
