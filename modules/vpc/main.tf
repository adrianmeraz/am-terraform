resource "aws_vpc" "main" {
  tags = var.tags

  cidr_block = var.cidr_block
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  tags = var.tags

  count = var.subnet_counts.public

  availability_zone = data.aws_availability_zones.available[count.index]
  cidr_block = var.public_subnet_blocks[count.index]
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "private" {
  tags = var.tags

  count = var.subnet_counts.private

  availability_zone = data.aws_availability_zones.available[count.index]
  cidr_block = var.private_subnet_blocks[count.index]
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  tags = var.tags

  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = module.subnet_public.id
  route_table_id = aws_route_table.main.id
}
