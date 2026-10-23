###############################################################################
# SQS Module – Variables
###############################################################################

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "queue_name" {
  type        = string
  default     = "order-events"
  description = "Base name for the SQS queue"
}

variable "visibility_timeout" {
  type        = number
  default     = 30
  description = "Visibility timeout in seconds for the queue"
}

variable "message_retention_seconds" {
  type        = number
  default     = 345600
  description = "Message retention period in seconds for the main queue (default 4 days)"
}

variable "dlq_message_retention_seconds" {
  type        = number
  default     = 1209600
  description = "Message retention period in seconds for the DLQ (default 14 days)"
}

variable "max_receive_count" {
  type        = number
  default     = 3
  description = "Number of receive attempts before a message is sent to the DLQ"
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "KMS key ID for server-side encryption (defaults to alias/aws/sqs)"
}

variable "alarm_sns_topic_arns" {
  type        = list(string)
  default     = []
  description = "List of SNS topic ARNs to notify when the DLQ alarm fires"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags applied to all resources"
}
