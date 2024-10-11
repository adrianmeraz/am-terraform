resource "aws_ssm_parameter" "secret" {
  name        = "/${var.app_name}/${var.environment}/secrets"
  overwrite   = true
  tier        = "Standard"
  data_type   = "text"
  type        = "SecureString"
  value       = <<EOF
  ${jsonencode(var.secret_map)}
EOF

  tags        = var.tags

  lifecycle {
    ignore_changes = [value]
  }


}

locals {
  secret_string = aws_ssm_parameter.secret.value
}