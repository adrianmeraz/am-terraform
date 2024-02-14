data "aws_ecr_authorization_token" "token" {}

resource  "aws_ecr_repository" "main" {
  name = "${var.name}_ecr"

  force_delete = var.force_delete
  image_tag_mutability = var.image_tag_mutability
  
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}
