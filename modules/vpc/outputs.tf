output "id" {
  description = "ID of VPC"
  value       = aws_vpc.this.id
}

output "security_group_id" {
  description = "Security group ID of VPC"
  value       = aws_vpc.this.default_security_group_id
}
