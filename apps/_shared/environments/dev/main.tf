#data "aws_default_tags" "main" {}
#
#locals {
#  app_name    = "expatmagic"
#  environment = "dev"
#  name_prefix = "${local.app_name}-${local.environment}"
#}
#
#module "network" {
#  source = "../../../../modules/network"
#
#  cidr_block = "10.0.0.0/16"
#
#  tags       = data.aws_default_tags.main.tags
#}
#
#locals {
#  private_subnet_ids = [for subnet in module.network.private_subnets: subnet.id]
#}
