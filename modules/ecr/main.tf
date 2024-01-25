resource  "aws_ecr_repository" "ecr" {
  tags = var.tags
  name = "${var.environment}-${var.name}"

  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = true
  }

}