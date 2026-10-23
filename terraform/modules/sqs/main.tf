###############################################################################
# SQS Module
# Wraps terraform-aws-modules/sqs/aws ~> 4.0
# Creates a main SQS queue with a dead-letter queue (DLQ) and a CloudWatch
# alarm that fires when messages land in the DLQ.
###############################################################################

locals {
  # Fall back to the AWS-managed SQS KMS key when no custom key is provided
  kms_key = var.kms_key_id != null ? var.kms_key_id : "alias/aws/sqs"
}

# ---------- Dead-Letter Queue (DLQ) ----------
module "dlq" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 4.0"

  name                       = "${var.project_name}-${var.environment}-${var.queue_name}-dlq"
  message_retention_seconds  = var.dlq_message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout
  kms_master_key_id          = local.kms_key

  tags = merge(var.tags, {
    Module      = "sqs"
    Environment = var.environment
    QueueType   = "dlq"
  })
}

# ---------- Main Queue ----------
module "main_queue" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 4.0"

  name                       = "${var.project_name}-${var.environment}-${var.queue_name}"
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout
  kms_master_key_id          = local.kms_key

  # Redrive policy: send failed messages to the DLQ
  # Note: terraform-aws-modules/sqs/aws internally calls jsonencode(), so pass a raw HCL map
  redrive_policy = {
    deadLetterTargetArn = module.dlq.queue_arn
    maxReceiveCount     = var.max_receive_count
  }

  tags = merge(var.tags, {
    Module      = "sqs"
    Environment = var.environment
    QueueType   = "main"
  })
}

# ---------- CloudWatch Alarm – DLQ messages visible ----------
# Triggers when any message becomes visible in the DLQ, indicating
# processing failures that require investigation.
resource "aws_cloudwatch_metric_alarm" "dlq_messages" {
  alarm_name          = "${var.project_name}-${var.environment}-${var.queue_name}-dlq-not-empty"
  alarm_description   = "Alarm when messages appear in the DLQ for ${var.queue_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  statistic           = "Sum"
  period              = 300
  threshold           = 0

  dimensions = {
    QueueName = module.dlq.queue_name
  }

  alarm_actions = var.alarm_sns_topic_arns

  tags = merge(var.tags, {
    Module      = "sqs"
    Environment = var.environment
  })
}
