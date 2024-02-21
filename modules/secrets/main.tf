resource "aws_secretsmanager_secret" "main" {
  name = var.name_prefix
  recovery_window_in_days = var.recovery_window_in_days

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "main" {
  version_stages = ["LATEST"]
  secret_id     = aws_secretsmanager_secret.main.id
  secret_string = <<EOF
  ${jsonencode(var.secret_map)}
EOF
}
