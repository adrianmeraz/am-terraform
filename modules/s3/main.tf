resource "aws_s3_bucket" "s3" {
  tags = var.tags
  bucket = var.bucket
}