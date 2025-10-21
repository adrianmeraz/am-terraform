locals {
  name = "/${var.app_name}/${var.environment}/secrets"
}

resource "aws_ssm_parameter" "secret" {
  name        = local.name
  tier        = "Standard"
  data_type   = "text"
  type        = "SecureString"
  value       = jsonencode(var.secret_map)

  tags        = var.tags

  lifecycle {
    ignore_changes = [value]
  }
}

locals {
  secret_string = aws_ssm_parameter.secret.value
}