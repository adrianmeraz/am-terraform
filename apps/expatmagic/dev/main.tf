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

module  "amec3" {
  source = "../../../apps/expatmagic/dev"
  #  ami           = "ami-04e914639d0cca79a"
#  instance_type = var.instance_type
#  tags = var.tags
}