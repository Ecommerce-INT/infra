###############################################################################
# ECR Module – Variables
###############################################################################

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "repositories" {
  type        = list(string)
  default     = ["catalog-service", "inventory-service", "order-service", "notification-worker", "frontend"]
  description = "List of ECR repository names to create"
}

variable "image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
  description = "Tag mutability setting for repositories (MUTABLE or IMMUTABLE)"
}

variable "max_image_count" {
  type        = number
  default     = 30
  description = "Maximum number of tagged images to retain per repository"
}

variable "untagged_image_expiry_days" {
  type        = number
  default     = 14
  description = "Number of days before untagged images are expired"
}

variable "force_delete" {
  type        = bool
  default     = false
  description = "Whether to force-delete repositories (and their images) on destroy"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags applied to all repositories"
}
