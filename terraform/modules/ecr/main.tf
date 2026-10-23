###############################################################################
# ECR Module
# Wraps terraform-aws-modules/ecr/aws ~> 2.0
# Creates one ECR repository per entry in var.repositories with KMS
# encryption, image scanning, immutable tags, and lifecycle policies.
###############################################################################

module "ecr" {
  source   = "terraform-aws-modules/ecr/aws"
  version  = "~> 2.0"
  for_each = toset(var.repositories)

  # ---------- Repository name ----------
  repository_name = "${var.project_name}-${var.environment}-${each.value}"

  # ---------- Image tag mutability ----------
  repository_image_tag_mutability = var.image_tag_mutability

  # ---------- Image scanning on push ----------
  repository_image_scan_on_push = true

  # ---------- Lifecycle policy ----------
  # Keep the last N tagged images and expire untagged images after a set number of days
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images after ${var.untagged_image_expiry_days} days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.untagged_image_expiry_days
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last ${var.max_image_count} tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = var.max_image_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  # ---------- Force delete (removes images on destroy) ----------
  repository_force_delete = var.force_delete

  # ---------- KMS encryption ----------
  repository_encryption_type = "KMS"

  # ---------- Tags ----------
  tags = merge(var.tags, {
    Module      = "ecr"
    Environment = var.environment
    Repository  = each.value
  })
}
