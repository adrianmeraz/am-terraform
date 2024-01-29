resource  "aws_ecr_repository" "ecr" {
  name = "${var.name}-${var.environment}-ecr"
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

  # Push a dummy image to avoid "No Valid Image Exists" errors
  provisioner "local-exec" {
    command = <<-EOT
      docker pull hello-world
      docker tag hello-world dummy_container
      docker push dummy_container
    EOT
  }
}
