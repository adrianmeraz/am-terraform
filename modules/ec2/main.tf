resource  "aws_instance" "ec2" {
  tags = merge(
    tomap({
      "app_name": var.app_name
      "environment": var.environment
    }),
    var.tags,
  )

  ami = var.ami
  instance_type = var.instance_type
}