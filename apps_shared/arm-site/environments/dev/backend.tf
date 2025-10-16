terraform {
  required_version = "1.13.3"

  backend "s3" {
    bucket  = "arm-site-dev-tfstate"
    region  = "us-west-2"
    key     = "arm-site-dev/terraform.tfstate"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.16.0"
    }
    time = {
      source = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
