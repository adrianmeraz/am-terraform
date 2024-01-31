resource "aws_vpc" "this" {
  tags = var.tags

  cidr_block = var.cidr_block
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
}
