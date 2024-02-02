resource "time_static" "this" {}

resource "aws_db_instance" "postgres_db" {
  allocated_storage         = var.allocated_storage
  engine                    = "postgres"
  engine_version            = "14.5"
  final_snapshot_identifier = "${var.identifier}-${time_static.this.unix}-final"
  identifier                = "${var.identifier}-db"
  instance_class            = var.instance_class
  password                  = var.password
  publicly_accessible       = false
  skip_final_snapshot       = var.skip_final_snapshot
  username                  = var.username
  vpc_security_group_ids    = var.vpc_security_group_ids
}