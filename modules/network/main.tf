resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = var.tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private" {
  count = var.subnet_counts.private

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.private_subnet_blocks[count.index]
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_route_table" "private" {
  # No route added since this is a private route table
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_route_table_association" "private" {
  count = var.subnet_counts.private

  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}

resource "aws_subnet" "public" {
  count = var.subnet_counts.public

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = var.public_subnet_blocks[count.index]
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "public" {
  count = var.subnet_counts.public

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}
