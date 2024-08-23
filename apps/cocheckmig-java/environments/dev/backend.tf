terraform {
  required_version = "1.8.1"

  backend "s3" {
    bucket  = "em-dev-tfstate"
    region  = "us-west-2"
    key     = "cocheckmig-java/terraform.tfstate"
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

provider "aws" {
  # us-east-1 instance
  region = "us-east-1"
  alias = "acm"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
