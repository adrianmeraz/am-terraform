resource "aws_vpc" "this" {
  tags = var.tags

  cidr_block = var.cidr_block
}
