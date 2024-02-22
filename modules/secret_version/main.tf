resource "aws_secretsmanager_secret_version" "main" {
  secret_id     = var.secret_id
  secret_string = <<EOF
  ${jsonencode(var.secret_map)}
EOF
}
