resource "aws_secretsmanager_secret" "main" {
  name = var.name
  recovery_window_in_days = var.recovery_window_in_days
  force_overwrite_replica_secret = var.force_overwrite_replica_secret

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "main" {
  secret_id     = aws_secretsmanager_secret.main.id
  secret_string = <<EOF
  ${jsonencode(var.secret_map)}
EOF
}
