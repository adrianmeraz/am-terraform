locals {
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_db_subnet_group" "main" {
  name = "${var.identifier}-postgres-sng"
  description = "DB Subnet for postgres DB"
  subnet_ids = var.private_subnet_ids
}

resource "aws_security_group" "main" {
  name        = "${var.identifier}-postgres-sg"
  description = "Allow incoming postgres traffic"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_postgres" {
  description       = "Allow incoming postgres traffic"
  cidr_ipv4         = local.cidr_ipv4
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.main.id

  tags = var.tags
}

resource "time_static" "main" {}

resource "aws_db_instance" "postgres_db" {
  allocated_storage         = var.allocated_storage
  db_name                   = var.db_name
  db_subnet_group_name      = aws_db_subnet_group.main.name
  engine                    = "postgres"
  engine_version            = "14.10"
  final_snapshot_identifier = "${var.identifier}-${time_static.main.unix}-final"
  identifier                = "${var.identifier}-postgres-db"
  instance_class            = var.instance_class
  password                  = var.password
  publicly_accessible       = false
  skip_final_snapshot       = false
  username                  = var.username
  vpc_security_group_ids    = [aws_security_group.main.id]
}
