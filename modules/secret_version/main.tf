

resource "aws_secretsmanager_secret_version" "main" {
  count = var.create_resource ? 1 : 0

  version_stages = ["LATEST"]
  secret_id     = var.secret_id
  secret_string = <<EOF
  ${jsonencode(var.secret_map)}
EOF
}
