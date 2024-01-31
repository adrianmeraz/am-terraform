resource "aws_secretsmanager_secret" "this" {
  name = "${var.name}/secret"
  tags = var.tags

  recovery_window_in_days = var.recovery_window_in_days
}

resource "aws_secretsmanager_secret_version" "r_secrets_version" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = <<EOF
  ${jsonencode(var.secret_map)}
EOF
}

# Importing the AWS secrets created previously using arn.

data "aws_secretsmanager_secret" "this" {
  arn = aws_secretsmanager_secret.this.arn
}

# Importing the AWS secret version created previously using arn.

data "aws_secretsmanager_secret_version" "this" {
  secret_id = data.aws_secretsmanager_secret.this.arn
}
