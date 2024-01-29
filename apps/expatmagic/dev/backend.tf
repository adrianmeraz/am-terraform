terraform {

  backend "s3" {
    bucket         = "expatmagic-tfstate-dev"
    region         = "us-west-2"
    key            = "expatmagic/terraform.tfstate"
#    encrypt        = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.32.1"
    }
    hcp = {
      source = "hashicorp/hcp"
      version = "0.63.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
