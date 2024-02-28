resource "aws_secretsmanager_secret" "main" {
  name = "${var.name_prefix}/secret"
  recovery_window_in_days = var.recovery_window_in_days

  tags = var.tags
}

# Must have duplicate, mutually exclusive resources to allow for forcefully redeploying secret version
# See https://stackoverflow.com/questions/62427931/terraform-conditionally-apply-lifecycle-block

resource "aws_secretsmanager_secret_version" "overwrite_false" {
  count = var.force_overwrite_secrets ? 0 : 1
  secret_id     = aws_secretsmanager_secret.main.id
  secret_string = <<EOF
  ${jsonencode(var.secret_map)}
EOF
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_secretsmanager_secret_version" "overwrite_true" {
  count = var.force_overwrite_secrets ? 1 : 0
  secret_id     = aws_secretsmanager_secret.main.id
  secret_string = <<EOF
  ${jsonencode(var.secret_map)}
EOF
}

locals {
  secret_string = var.force_overwrite_secrets ? aws_secretsmanager_secret_version.overwrite_true[0].secret_string : aws_secretsmanager_secret_version.overwrite_false[0].secret_string
}