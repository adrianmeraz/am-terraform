terraform {
  required_version = "1.7.1"

  backend "s3" {
    profile = "expatmagic"
    bucket  = "em-prod-tfstate"
    region  = "us-west-2"
    key     = "em-prod/terraform.tfstate"
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
  profile = "expatmagic"
  default_tags {
    tags = {
      "app_name" :    local.app_name
      "environment" : local.environment
    }
  }
}
