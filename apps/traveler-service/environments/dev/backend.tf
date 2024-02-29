terraform {
  required_version = "1.7.1"

  backend "s3" {
    bucket = "traveler-service-dev-tfstate"
    region = "us-west-2"
    key    = "traveler-service-dev/terraform.tfstate"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.32.1"
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
  default_tags {
    tags = {
      "app_name" :    local.app_name
      "environment" : local.environment
    }
  }
}
