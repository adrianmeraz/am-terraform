terraform {
  required_version = "1.7.1"

  backend "s3" {
    bucket = "expatmagic-secret-tfstate-dev"
    region = "us-west-2"
    key    = "expatmagic-secret/terraform.tfstate"
#    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.32.1"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.63.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.10.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  default_tags {
    tags = {
      "app_name" :    local.app_name
      "environment" : local.environment
    }
  }
}
