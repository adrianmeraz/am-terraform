resource "aws_s3_bucket" "s3" {
  tags = merge(
    tomap({
      "app_name": var.app_name
      "environment": var.environment
    }),
    var.tags,
  )
  bucket = "${var.app_name}-${var.environment}-${var.bucket}"
}