resource  "aws_ecr_repository" "ecr" {
  name = "${var.environment}-${var.name}-ecr"
  tags = merge(
    tomap({
      "app_name": var.app_name
      "environment": var.environment
    }),
    var.tags,
  )

  image_tag_mutability = var.image_tag_mutability
  
  image_scanning_configuration {
    scan_on_push = true
  }

  provisioner "local-exec" {
    command = <<-EOT
      docker pull alpine
      docker tag alpine dummy_container
      docker push dummy_container
    EOT
  }
}
