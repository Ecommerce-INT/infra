################################################################################
# Main – Dev Environment
# Calls all reusable modules and wires their outputs together
################################################################################

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# =============================================================================
# 1. NETWORKING – VPC, Subnets, NAT Gateway, S3 Endpoint
# =============================================================================

module "networking" {
  source = "../../modules/networking"

  environment  = var.environment
  project_name = var.project_name

  vpc_cidr              = var.vpc_cidr
  azs                   = var.azs
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs

  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  tags = local.common_tags
}

# =============================================================================
# 2. EKS – Cluster, Managed Node Groups, Addons, Access Entries
# =============================================================================

module "eks" {
  source = "../../modules/eks"

  environment  = var.environment
  project_name = var.project_name

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnets

  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  node_instance_types = var.node_instance_types
  node_capacity_type  = var.node_capacity_type
  node_min_size       = var.node_min_size
  node_desired_size   = var.node_desired_size
  node_max_size       = var.node_max_size
  node_disk_size      = var.node_disk_size

  tags = local.common_tags
}

# =============================================================================
# 3. ECR – Container Registries
# =============================================================================

module "ecr" {
  source = "../../modules/ecr"

  environment  = var.environment
  project_name = var.project_name

  image_tag_mutability = var.ecr_image_tag_mutability
  force_delete         = var.ecr_force_delete

  tags = local.common_tags
}

# =============================================================================
# 4. RDS – PostgreSQL Database
# =============================================================================

module "rds" {
  source = "../../modules/rds"

  environment  = var.environment
  project_name = var.project_name

  vpc_id                     = module.networking.vpc_id
  database_subnet_group_name = module.networking.database_subnet_group_name
  eks_node_security_group_id = module.eks.node_security_group_id

  instance_class        = var.rds_instance_class
  multi_az              = var.rds_multi_az
  allocated_storage     = var.rds_allocated_storage
  max_allocated_storage = var.rds_max_allocated_storage

  backup_retention_period = var.rds_backup_retention_period
  deletion_protection     = var.rds_deletion_protection
  skip_final_snapshot     = var.rds_skip_final_snapshot

  tags = local.common_tags
}

# =============================================================================
# 5. SQS – Order Events Queue + Dead Letter Queue
# =============================================================================

module "sqs" {
  source = "../../modules/sqs"

  environment  = var.environment
  project_name = var.project_name

  visibility_timeout = var.sqs_visibility_timeout
  max_receive_count  = var.sqs_max_receive_count

  tags = local.common_tags
}

# =============================================================================
# 6. WORKLOAD IAM – IRSA for ESO, Order Service, Notification Worker
# =============================================================================

module "workload_iam" {
  source = "../../modules/workload-iam"

  environment  = var.environment
  project_name = var.project_name

  oidc_provider_arn = module.eks.oidc_provider_arn
  sqs_queue_arn     = module.sqs.queue_arn

  # Scope secrets access to RDS master secret
  secrets_arns = [module.rds.db_master_user_secret_arn]

  tags = local.common_tags
}
