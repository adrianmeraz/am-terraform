resource "aws_secretsmanager_secret" "main" {
  name = "${var.name}/secret"
  tags = var.tags

  recovery_window_in_days = var.recovery_window_in_days
}

resource "aws_secretsmanager_secret_version" "r_secrets_version" {
  secret_id = aws_secretsmanager_secret.main.id
  secret_string = <<EOF
  ${jsonencode(var.secret_map)}
EOF
}
