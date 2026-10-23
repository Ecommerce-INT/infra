###############################################################################
# SQS Module – Outputs
###############################################################################

output "queue_url" {
  description = "URL of the main SQS queue"
  value       = module.main_queue.queue_url
}

output "queue_arn" {
  description = "ARN of the main SQS queue"
  value       = module.main_queue.queue_arn
}

output "queue_name" {
  description = "Name of the main SQS queue"
  value       = module.main_queue.queue_name
}

output "dlq_url" {
  description = "URL of the dead-letter queue"
  value       = module.dlq.queue_url
}

output "dlq_arn" {
  description = "ARN of the dead-letter queue"
  value       = module.dlq.queue_arn
}

output "dlq_name" {
  description = "Name of the dead-letter queue"
  value       = module.dlq.queue_name
}
