resource "aws_subnet" "subnet_public" {
  tags = var.tags

  vpc_id = var.vpc_id
  cidr_block = var.cidr_block
  map_public_ip_on_launch = "true"
  availability_zone = var.availability_zone
}