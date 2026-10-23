################################################################################
# EKS Cluster Module
# Wraps terraform-aws-modules/eks/aws ~> 20.0
# Provisions: KMS key for secrets encryption, EKS cluster with managed node
# groups, EKS addons (CoreDNS, kube-proxy, VPC-CNI, EBS CSI), and IRSA for
# the EBS CSI driver.
################################################################################

# --------------------------------------------------------------------------
# KMS Key for EKS secrets encryption
# --------------------------------------------------------------------------
module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 3.0"

  description             = "KMS key for EKS ${var.project_name}-${var.environment} secrets encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  aliases = ["eks/${var.project_name}-${var.environment}"]
  tags    = var.tags
}

# --------------------------------------------------------------------------
# EKS Cluster
# --------------------------------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-${var.environment}"
  cluster_version = var.cluster_version

  # Networking
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Endpoint access
  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  # Logging – enable all control plane log types
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Encryption – use the dedicated KMS key created above
  create_kms_key = false
  cluster_encryption_config = {
    provider_key_arn = module.kms.key_arn
    resources        = ["secrets"]
  }

  # --------------------------------------------------------------------------
  # EKS Managed Add-ons
  # --------------------------------------------------------------------------
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa.iam_role_arn
    }
  }

  # --------------------------------------------------------------------------
  # EKS Managed Node Groups
  # --------------------------------------------------------------------------
  eks_managed_node_groups = {
    main = {
      name           = "${var.project_name}-${var.environment}-main"
      instance_types = var.node_instance_types
      capacity_type  = var.node_capacity_type

      min_size     = var.node_min_size
      desired_size = var.node_desired_size
      max_size     = var.node_max_size

      # Security – enforce IMDSv2
      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
      }

      # EBS encryption for node root volume
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = var.node_disk_size
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }

      labels = merge(var.node_labels, {
        "environment" = var.environment
      })

      tags = var.tags
    }
  }

  # --------------------------------------------------------------------------
  # Access Entries (modern replacement for aws-auth ConfigMap)
  # --------------------------------------------------------------------------
  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = "API_AND_CONFIG_MAP"

  access_entries = var.access_entries

  tags = var.tags
}

# --------------------------------------------------------------------------
# IRSA for EBS CSI Driver
# --------------------------------------------------------------------------
module "ebs_csi_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name             = "${var.project_name}-${var.environment}-ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = var.tags
}
