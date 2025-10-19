resource "aws_dynamodb_table" "main" {
  name             = "${var.name_prefix}-table"
  hash_key         = var.hash_key_name
  range_key        = var.range_key_name
  billing_mode     = var.billing_mode
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  ttl {
    enabled = var.ttl_attr_name != ""
    attribute_name = var.ttl_attr_name
  }

  attribute {
    name = var.hash_key_name
    type = "S"
  }

  attribute {
    name = var.range_key_name
    type = "S"
  }

  tags = var.tags
}