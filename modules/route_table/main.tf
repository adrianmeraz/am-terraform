resource "aws_route_table" "this" {
  tags = var.tags

  vpc_id = var.vpc_id
  route {
    cidr_block = var.route.cidr_block
    gateway_id = var.route.gateway_id
  }
}