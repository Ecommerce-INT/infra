################################################################################
# Dev Environment – Variable Values
# Cost-optimized: Single NAT, Spot nodes, Single-AZ RDS
################################################################################

# General
aws_region   = "us-east-1"
environment  = "dev"
project_name = "ecommerce"

# --------------------------------------------------------------------------
# Networking
# --------------------------------------------------------------------------
vpc_cidr = "10.10.0.0/16"
azs      = ["us-east-1a", "us-east-1b"]

public_subnet_cidrs   = ["10.10.1.0/24", "10.10.2.0/24"]
private_subnet_cidrs  = ["10.10.10.0/24", "10.10.11.0/24"]
database_subnet_cidrs = ["10.10.20.0/24", "10.10.21.0/24"]

single_nat_gateway     = true # 1 NAT Gateway dùng chung – tiết kiệm ~$70/tháng
one_nat_gateway_per_az = false

# --------------------------------------------------------------------------
# EKS
# --------------------------------------------------------------------------
cluster_version                = "1.31"
cluster_endpoint_public_access = true

node_instance_types = ["t3.medium"]
node_capacity_type  = "SPOT" # Spot instances – tiết kiệm tới 70%
node_min_size       = 1
node_desired_size   = 2
node_max_size       = 3
node_disk_size      = 50

# --------------------------------------------------------------------------
# RDS PostgreSQL
# --------------------------------------------------------------------------
rds_instance_class          = "db.t4g.micro"
rds_multi_az                = false # Single-AZ cho dev
rds_allocated_storage       = 20
rds_max_allocated_storage   = 50
rds_backup_retention_period = 7
rds_deletion_protection     = false
rds_skip_final_snapshot     = true

# --------------------------------------------------------------------------
# ECR
# --------------------------------------------------------------------------
ecr_image_tag_mutability = "MUTABLE" # Linh hoạt cho dev
ecr_force_delete         = true      # Cho phép xóa repo khi destroy

# --------------------------------------------------------------------------
# SQS
# --------------------------------------------------------------------------
sqs_visibility_timeout = 30
sqs_max_receive_count  = 3
