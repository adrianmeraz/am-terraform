resource "time_static" "this" {}

resource "aws_db_instance" "rds" {
  allocated_storage         = var.allocated_storage
  engine                    = var.engine
  engine_version            = var.engine_version
  final_snapshot_identifier = "${var.identifier}-${time_static.this.unix}-final"
  identifier                = "${var.identifier}-db"
  instance_class            = var.instance_class
  password                  = var.password
  publicly_accessible       = var.publicly_accessible
  skip_final_snapshot       = var.skip_final_snapshot
  username                  = var.username
}