resource "aws_secretsmanager_secret" "main" {
  name = "${var.name_prefix}/secret"
  recovery_window_in_days = var.recovery_window_in_days

  lifecycle {
    ignore_changes = all
  }

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "main" {
  secret_id     = aws_secretsmanager_secret.main.id
  secret_string = <<EOF
  ${jsonencode(var.secret_map)}
EOF
  lifecycle {
    ignore_changes = all
  }
}
