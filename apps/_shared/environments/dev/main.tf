#data "aws_secretsmanager_secret" "main" {
#  name = var.aws_secretsmanager_secret_name
#}
#
#data "aws_secretsmanager_secret_version" "main" {
#  secret_id = data.aws_secretsmanager_secret.main.id
#}
#
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
