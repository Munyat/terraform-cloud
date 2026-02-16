terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "brian-dev-terraform-state-unique-name"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"  # Changed from ~> 5.0 to ~> 6.0
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
}