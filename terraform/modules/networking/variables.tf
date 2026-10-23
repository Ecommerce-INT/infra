###############################################################################
# Networking Module – Variables
###############################################################################

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnet CIDR blocks"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnet CIDR blocks"
}

variable "database_subnet_cidrs" {
  type        = list(string)
  description = "Database subnet CIDR blocks"
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "Use a single NAT Gateway (cost saving for non-prod)"
}

variable "one_nat_gateway_per_az" {
  type        = bool
  default     = false
  description = "Create one NAT Gateway per AZ (HA for prod)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags applied to all resources"
}
