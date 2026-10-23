###############################################################################
# ECR Module – Outputs
###############################################################################

output "repository_urls" {
  description = "Map of repository name to its URL"
  value = {
    for name, repo in module.ecr : name => repo.repository_url
  }
}

output "repository_arns" {
  description = "Map of repository name to its ARN"
  value = {
    for name, repo in module.ecr : name => repo.repository_arn
  }
}
