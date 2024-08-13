terraform {
  required_version = "1.8.1"

  backend "s3" {
    bucket  = "captcha-service-dev-tfstate"
    region  = "us-west-2"
    key     = "captcha-service-dev/terraform.tfstate"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.40.0"
    }
    time = {
      source = "hashicorp/time"
      version = "0.10.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
