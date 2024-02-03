output "id" {
  description = "ID of VPC"
  value       = aws_vpc.this.id
}

output "security_group_id" {
  description = "Security group ID of VPC"
  value       = aws_vpc.this.default_security_group_id
}

output "public_subnets" {
  description = "All public subnets of VPC"
  value       = var.public_subnet_blocks
}

output "private_subnets" {
  description = "All private subnets of VPC"
  value       = var.private_subnet_blocks
}
