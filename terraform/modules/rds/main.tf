################################################################################
# RDS PostgreSQL Module
# Wraps terraform-aws-modules/rds/aws ~> 6.0
# Provisions: KMS key for storage encryption, dedicated security group
# (ingress from EKS nodes only), and a PostgreSQL RDS instance with
# enhanced monitoring, Secrets Manager managed password, and encrypted storage.
################################################################################

# --------------------------------------------------------------------------
# KMS Key for RDS storage encryption
# --------------------------------------------------------------------------
module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 3.0"

  description             = "KMS key for RDS ${var.project_name}-${var.environment}"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  aliases = ["rds/${var.project_name}-${var.environment}"]
  tags    = var.tags
}

# --------------------------------------------------------------------------
# Security Group for RDS – only allow inbound from EKS nodes
# --------------------------------------------------------------------------
module "rds_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.project_name}-${var.environment}-rds"
  description = "Security group for RDS PostgreSQL - allow inbound from EKS nodes only"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      description              = "PostgreSQL from EKS nodes"
      source_security_group_id = var.eks_node_security_group_id
    }
  ]

  tags = var.tags
}

# --------------------------------------------------------------------------
# RDS PostgreSQL Instance
# --------------------------------------------------------------------------
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier = "${var.project_name}-${var.environment}"

  engine               = "postgres"
  engine_version       = var.engine_version
  family               = "postgres16"
  major_engine_version = "16"
  instance_class       = var.instance_class

  # Storage
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true
  kms_key_id            = module.kms.key_arn

  # Database
  db_name  = var.db_name
  username = var.db_username
  port     = 5432

  # Master password via Secrets Manager (no plaintext password in state)
  manage_master_user_password = true

  # High availability
  multi_az = var.multi_az

  # Network
  db_subnet_group_name   = var.database_subnet_group_name
  vpc_security_group_ids = [module.rds_security_group.security_group_id]
  publicly_accessible    = false

  # Backup & Maintenance
  backup_retention_period = var.backup_retention_period
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection
  copy_tags_to_snapshot   = true

  # Enhanced Monitoring
  monitoring_interval    = 60
  monitoring_role_name   = "${var.project_name}-${var.environment}-rds-monitoring"
  create_monitoring_role = true

  # CloudWatch Log Exports
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # Parameter Group – security & observability defaults
  parameters = [
    {
      name  = "log_connections"
      value = "1"
    },
    {
      name  = "log_disconnections"
      value = "1"
    },
    {
      name  = "log_checkpoints"
      value = "1"
    }
  ]

  tags = var.tags
}
