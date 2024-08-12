resource "aws_secretsmanager_secret" "main" {
  name                    = "${var.secret_name_prefix}/secret"
  recovery_window_in_days = var.recovery_window_in_days

  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "main" {
  secret_id     = aws_secretsmanager_secret.main.id
  secret_string = <<EOF
  ${jsonencode(var.secret_map)}
EOF
  lifecycle {
    ignore_changes = [secret_string]
  }
}

locals {
  secret_string = aws_secretsmanager_secret_version.main.secret_string
}