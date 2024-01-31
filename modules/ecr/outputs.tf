output "repository_arn" {
  description = "Full ARN of the repository"
  value       = aws_ecr_repository.this.arn
}

output "repository_registry_id" {
  description = "The registry ID where the repository was created"
  value       = aws_ecr_repository.this.registry_id
}

output "repository_url" {
  description = "The URL of the repository (in the form `aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName`)"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_url_with_tag" {
  description = "The Full URL of the repository including the tag (in the form `aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName:tagName`)"
  value       = "${aws_ecr_repository.this.repository_url}:${var.image_tag}"
}

