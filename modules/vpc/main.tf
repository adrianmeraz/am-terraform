resource "aws_vpc" "this" {
  tags = var.tags

  cidr_block = var.cidr_block
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = var.tags
}

module "subnet_public" {
  source = "../../modules/subnet"
  tags = var.tags

  vpc_id = aws_vpc.this.id
  cidr_block = var.cidr_block
  map_public_ip_on_launch = true
  availability_zone = var.availability_zones[0]
}

module "subnet_private" {
  source = "../../modules/subnet"
  tags = var.tags

  availability_zone = var.availability_zones[0]
  cidr_block = var.private_subnets[0]
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "this" {
  tags = var.tags

  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = module.subnet_public.id
  route_table_id = aws_route_table.this.id
}
