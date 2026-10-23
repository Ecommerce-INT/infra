################################################################################
# EKS Module – Input Variables
################################################################################

variable "environment" {
  type        = string
  description = "Environment name (e.g. dev, staging, prod)"
}

variable "project_name" {
  type        = string
  description = "Project name prefix used for resource naming"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the EKS cluster will be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for EKS worker nodes"
}

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

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDR blocks allowed to access the EKS public API endpoint"
}

# --------------------------------------------------------------------------
# Node Group Configuration
# --------------------------------------------------------------------------

variable "node_instance_types" {
  type        = list(string)
  default     = ["t3.medium"]
  description = "EC2 instance types for the managed node group"
}

variable "node_capacity_type" {
  type        = string
  default     = "SPOT"
  description = "Capacity type for the managed node group – SPOT or ON_DEMAND"
}

variable "node_min_size" {
  type        = number
  default     = 1
  description = "Minimum number of nodes in the managed node group"
}

variable "node_desired_size" {
  type        = number
  default     = 2
  description = "Desired number of nodes in the managed node group"
}

variable "node_max_size" {
  type        = number
  default     = 3
  description = "Maximum number of nodes in the managed node group"
}

variable "node_disk_size" {
  type        = number
  default     = 50
  description = "Root EBS volume size in GiB for worker nodes"
}

variable "node_labels" {
  type        = map(string)
  default     = {}
  description = "Kubernetes labels to apply to managed node group nodes"
}

# --------------------------------------------------------------------------
# Access Configuration
# --------------------------------------------------------------------------

variable "access_entries" {
  type        = any
  default     = {}
  description = "EKS access entries map for cluster authentication"
}

# --------------------------------------------------------------------------
# Tags
# --------------------------------------------------------------------------

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to apply to all resources"
}
