################################################################################
# Workload IAM Module
# Creates IRSA (IAM Roles for Service Accounts) roles for EKS workloads
# using terraform-aws-modules/iam/aws ~> 5.0.
#
# Roles provisioned:
#   1. External Secrets Operator (ESO) – reads from AWS Secrets Manager
#   2. Order Service              – publishes messages to SQS
#   3. Notification Worker        – consumes messages from SQS
################################################################################

# --------------------------------------------------------------------------
# IRSA Role: External Secrets Operator (ESO)
# Allows ESO to read secrets from AWS Secrets Manager
# --------------------------------------------------------------------------
module "eso_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.project_name}-${var.environment}-eso"

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.eso_namespace}:${var.eso_service_account}"]
    }
  }

  role_policy_arns = {
    eso = aws_iam_policy.eso.arn
  }

  tags = var.tags
}

resource "aws_iam_policy" "eso" {
  name        = "${var.project_name}-${var.environment}-eso-secrets"
  description = "Allow ESO to read secrets from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ]
        Resource = var.secrets_arns
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = var.kms_key_arns
      }
    ]
  })

  tags = var.tags
}

# --------------------------------------------------------------------------
# IRSA Role: Order Service
# Allows publishing messages to the SQS order-events queue
# --------------------------------------------------------------------------
module "order_service_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.project_name}-${var.environment}-order-service"

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.app_namespace}:order-service"]
    }
  }

  role_policy_arns = {
    sqs_send = aws_iam_policy.order_sqs_send.arn
  }

  tags = var.tags
}

resource "aws_iam_policy" "order_sqs_send" {
  name        = "${var.project_name}-${var.environment}-order-sqs-send"
  description = "Allow Order Service to send messages to SQS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes"
        ]
        Resource = [var.sqs_queue_arn]
      },
      {
        Effect   = "Allow"
        Action   = ["kms:GenerateDataKey", "kms:Decrypt"]
        Resource = var.kms_key_arns
      }
    ]
  })

  tags = var.tags
}

# --------------------------------------------------------------------------
# IRSA Role: Notification Worker
# Allows consuming messages from the SQS order-events queue
# --------------------------------------------------------------------------
module "notification_worker_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.project_name}-${var.environment}-notification-worker"

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${var.app_namespace}:notification-worker"]
    }
  }

  role_policy_arns = {
    sqs_consume = aws_iam_policy.worker_sqs_consume.arn
  }

  tags = var.tags
}

resource "aws_iam_policy" "worker_sqs_consume" {
  name        = "${var.project_name}-${var.environment}-worker-sqs-consume"
  description = "Allow Notification Worker to consume messages from SQS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ChangeMessageVisibility"
        ]
        Resource = [var.sqs_queue_arn]
      },
      {
        Effect   = "Allow"
        Action   = ["kms:Decrypt"]
        Resource = var.kms_key_arns
      }
    ]
  })

  tags = var.tags
}
