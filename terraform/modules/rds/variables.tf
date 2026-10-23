################################################################################
# RDS Module – Input Variables
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
  description = "VPC ID where the RDS instance will be deployed"
}

variable "database_subnet_group_name" {
  type        = string
  description = "Name of the DB subnet group for the RDS instance"
}

variable "eks_node_security_group_id" {
  type        = string
  description = "EKS node security group ID – used to allow inbound PostgreSQL traffic to RDS"
}

variable "engine_version" {
  type        = string
  default     = "16.4"
  description = "PostgreSQL engine version"
}

variable "instance_class" {
  type        = string
  default     = "db.t4g.micro"
  description = "RDS instance class"
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "Initial allocated storage in GiB"
}

variable "max_allocated_storage" {
  type        = number
  default     = 100
  description = "Maximum storage threshold in GiB for autoscaling"
}

variable "db_name" {
  type        = string
  default     = "appdb"
  description = "Name of the initial database to create"
}

variable "db_username" {
  type        = string
  default     = "dbadmin"
  description = "Master username for the RDS instance"
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "Enable Multi-AZ deployment for high availability"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "Number of days to retain automated backups"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = true
  description = "Whether to skip the final DB snapshot on deletion"
}

variable "deletion_protection" {
  type        = bool
  default     = false
  description = "Enable deletion protection on the RDS instance"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to apply to all resources"
}
