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

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_rds_cluster" "postgresql" {
  availability_zones        = data.aws_availability_zones.available.names
  backup_retention_period   = 5
  cluster_identifier        = "${var.identifier}-postgresql-cluster"
  database_name             = var.db_name
  db_subnet_group_name      = aws_db_subnet_group.main.name
  engine                    = "aurora-postgresql"
  final_snapshot_identifier = "${var.identifier}-${time_static.main.unix}-final"
  master_username           = var.username
  master_password           = var.password
  preferred_backup_window   = "03:00-05:00"
  vpc_security_group_ids    = [aws_security_group.main.id]
}
