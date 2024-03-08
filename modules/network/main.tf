locals {
  public_subnet_blocks  = [for index in range(var.subnet_counts.public): cidrsubnet(var.cidr_block, 8, index+1)]
  private_subnet_blocks = [for index in range(var.subnet_counts.private): cidrsubnet(var.cidr_block, 8, index+101)]
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = "${var.name_prefix}-vpc"
    }
    var.tags
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = data.aws_availability_zones.available.names
}

resource "aws_subnet" "private" {
  count = var.subnet_counts.private

  availability_zone = local.availability_zones[count.index % length(local.availability_zones)]
  cidr_block = local.private_subnet_blocks[count.index]
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

  availability_zone = local.availability_zones[count.index % length(local.availability_zones)]
  cidr_block = local.public_subnet_blocks[count.index]
  map_public_ip_on_launch = true
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_route_table" "public_allow_all" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "public" {
  count = var.subnet_counts.public

  route_table_id = aws_route_table.public_allow_all.id
  subnet_id      = aws_subnet.public[count.index].id
}
