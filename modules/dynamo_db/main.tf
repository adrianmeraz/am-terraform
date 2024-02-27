locals {
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_dynamodb_table" "example" {
  name             = "${var.name_prefix}-table"
  hash_key         = var.hash_key
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  replica {
    region_name = "us-east-2"
  }

  tags = var.tags
}