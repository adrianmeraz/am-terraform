data "aws_ecr_authorization_token" "token" {}

resource  "aws_ecr_repository" "this" {
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

  # This is a 1-time execution to put a dummy image into the ECR repo, so
  # terraform provisioning works on the lambda function. Otherwise there is
  # a chicken-egg scenario where the lambda can't be provisioned because no
  # image exists in the ECR
  provisioner "local-exec" {
    command = <<-EOT
      docker login ${data.aws_ecr_authorization_token.token.proxy_endpoint} -u AWS -p ${data.aws_ecr_authorization_token.token.password}
      docker pull hello-world
      docker tag hello-world ${self.repository_url}:latest
      docker push ${self.repository_url}:latest
    EOT
  }
}
