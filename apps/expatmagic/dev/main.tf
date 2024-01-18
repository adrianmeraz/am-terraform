#module  "ec2" {
#  source = "../modules/ec2"
#  ami           = "ami-04e914639d0cca79a"
#  instance_type = "t4g.nano"
#  tags = {
#    "Environment": "dev"
#  }
#}
module  "ecr" {
  ecr_name = "em-ecr"
  source = "../../../modules/ecr"
  environment = "dev"
  tags = {
    "environment": "dev"
  }
}