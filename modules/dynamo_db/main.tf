resource "aws_dynamodb_table" "main" {
  name             = "${var.name_prefix}-table"
  hash_key         = "PK"
  range_key        = "SK"
  billing_mode     = var.billing_mode
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  ttl {
    enabled = true
    attribute_name = "ExpiresAt"
  }

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

#  lifecycle {
#    prevent_destroy = true
#  }

  tags = var.tags
}