resource "aws_db_instance" "rds" {
  allocated_storage         = var.allocated_storage
  engine                    = var.engine
  engine_version            = var.engine_version
  final_snapshot_identifier = "${var.identifier}-${var.environment}-final"
  identifier                = "${var.identifier}-${var.environment}-db"
  instance_class            = var.instance_class
  password                  = var.password
  publicly_accessible       = var.publicly_accessible
  skip_final_snapshot       = var.skip_final_snapshot
  username                  = var.username
}