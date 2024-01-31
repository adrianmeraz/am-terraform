resource  "aws_instance" "ec2" {
  tags = var.tags

  ami = var.ami
  instance_type = var.instance_type
}