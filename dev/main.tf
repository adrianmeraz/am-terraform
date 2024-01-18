#module "am_ecr" {
#  source = "../../../modules/ecr"
#}
#module "am_ec2" {
#  source = "../../../modules/ec2"
#}

#terraform {
#  required_providers {
#    aws = {
#      source = "hashicorp/aws"
#      version = "~> 5.32"
#    }
#  }
#}
#
#provider "aws" {
#  region = "us-west-2"
#}

module  "ec2" {
  source = "../modules/ec2"
  #  ami           = "ami-04e914639d0cca79a"
  instance_type = "t4g.nano"
  tags = {
    "Environment": "dev"
  }
}