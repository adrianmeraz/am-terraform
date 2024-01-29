resource "aws_secretsmanager_secret" "r_secrets" {
  name = "${var.app_name}-${var.environment}-secret"
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "r_secrets_version" {
  secret_id = aws_secretsmanager_secret.r_secrets.id
  secret_string = <<EOF
  ${var.secret_map}
EOF
}

# Importing the AWS secrets created previously using arn.

data "aws_secretsmanager_secret" "d_secrets" {
  arn = aws_secretsmanager_secret.r_secrets.arn
}

# Importing the AWS secret version created previously using arn.

data "aws_secretsmanager_secret_version" "d_secrets_version" {
  secret_id = data.aws_secretsmanager_secret.d_secrets.arn
}
