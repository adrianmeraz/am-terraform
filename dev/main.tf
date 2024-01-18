#module  "ec2" {
#  source = "../modules/ec2"
#  ami           = "ami-04e914639d0cca79a"
#  instance_type = "t4g.nano"
#  tags = {
#    "Environment": "dev"
#  }
#}
module  "ecr" {
  source = "../modules/ecr"
  instance_type = "t4g.nano"
  tags = {
    "environment": "dev",
    "environment": "dev",
  }
}