###############################################################################
# Networking Module
# Wraps terraform-aws-modules/vpc/aws ~> 5.0
# Creates a VPC with public, private, and database subnets, NAT gateways,
# VPC flow logs, and a locked-down default security group.
###############################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  # ---------- VPC basics ----------
  name = "${var.project_name}-${var.environment}-vpc"
  cidr = var.vpc_cidr
  azs  = var.azs

  # ---------- Subnet CIDRs ----------
  public_subnets   = var.public_subnet_cidrs
  private_subnets  = var.private_subnet_cidrs
  database_subnets = var.database_subnet_cidrs

  # ---------- Public subnet tags (for AWS LB Controller) ----------
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  # ---------- Private subnet tags (for internal LBs) ----------
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  # ---------- Database subnet configuration ----------
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false

  # ---------- NAT Gateway configuration ----------
  enable_nat_gateway     = true
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  # ---------- DNS settings ----------
  enable_dns_hostnames = true
  enable_dns_support   = true

  # ---------- Lock down the default security group ----------
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  # ---------- VPC Flow Logs to CloudWatch ----------
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  # ---------- Common tags ----------
  tags = merge(var.tags, {
    Module      = "networking"
    Environment = var.environment
  })
}

# -----------------------------------------------------------------------------
# S3 Gateway Endpoint (Week 2 Requirement: Direct, free traffic to S3 from VPC)
# -----------------------------------------------------------------------------
data "aws_region" "current" {}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.vpc.private_route_table_ids

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-s3-endpoint"
    Environment = var.environment
  })
}
