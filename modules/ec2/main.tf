resource  "aws_instance" "ec2" {
  instance_type = var.instance_type
  tags = var.tags
}