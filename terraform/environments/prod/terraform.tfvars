################################################################################
# Prod Environment – Variable Values
# Production-grade: 3 NAT (HA), On-Demand nodes, Multi-AZ RDS, Deletion Protection
################################################################################

# General
aws_region   = "us-east-1"
environment  = "prod"
project_name = "ecommerce"

# --------------------------------------------------------------------------
# Networking
# --------------------------------------------------------------------------
vpc_cidr = "10.30.0.0/16"
azs      = ["us-east-1a", "us-east-1b", "us-east-1c"]

public_subnet_cidrs   = ["10.30.1.0/24", "10.30.2.0/24", "10.30.3.0/24"]
private_subnet_cidrs  = ["10.30.10.0/24", "10.30.11.0/24", "10.30.12.0/24"]
database_subnet_cidrs = ["10.30.20.0/24", "10.30.21.0/24", "10.30.22.0/24"]

single_nat_gateway     = false # 3 NAT Gateways – High Availability (1 per AZ)
one_nat_gateway_per_az = true

# --------------------------------------------------------------------------
# EKS
# --------------------------------------------------------------------------
cluster_version                = "1.31"
cluster_endpoint_public_access = true

node_instance_types = ["m6i.large"]
node_capacity_type  = "ON_DEMAND" # On-Demand cho production – đảm bảo SLA ổn định
node_min_size       = 3
node_desired_size   = 3
node_max_size       = 8
node_disk_size      = 80

# --------------------------------------------------------------------------
# RDS PostgreSQL
# --------------------------------------------------------------------------
rds_instance_class          = "db.r6g.large"
rds_multi_az                = true # Multi-AZ cho production – tự động failover
rds_allocated_storage       = 50
rds_max_allocated_storage   = 200
rds_backup_retention_period = 30
rds_deletion_protection     = true  # Bảo vệ chống xóa nhầm
rds_skip_final_snapshot     = false # Tạo snapshot trước khi xóa

# --------------------------------------------------------------------------
# ECR
# --------------------------------------------------------------------------
ecr_image_tag_mutability = "IMMUTABLE"
ecr_force_delete         = false

# --------------------------------------------------------------------------
# SQS
# --------------------------------------------------------------------------
sqs_visibility_timeout = 30
sqs_max_receive_count  = 3
