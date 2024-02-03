data "aws_ecr_authorization_token" "token" {}

resource  "aws_ecr_repository" "main" {
  name = "${var.name}_ecr"
  tags = var.tags

  force_delete = var.force_delete
  image_tag_mutability = var.image_tag_mutability
  
  image_scanning_configuration {
    scan_on_push = true
  }

  # This is a 1-time execution to put a dummy image into the ECR repo, so
  # terraform provisioning works on the lambda function. Otherwise there is
  # a chicken-egg scenario where the lambda can't be provisioned because no
  # image exists in the ECR
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<-EOT
      docker login ${data.aws_ecr_authorization_token.token.proxy_endpoint} -u AWS -p ${data.aws_ecr_authorization_token.token.password}
      docker pull hello-world
      docker tag hello-world:${var.image_tag} ${self.repository_url}:${var.image_tag}
      docker push ${self.repository_url}:${var.image_tag}
    EOT
  }
}
