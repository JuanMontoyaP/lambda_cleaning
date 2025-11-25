terraform {
  required_version = "~> 1.14.0"

  backend "s3" {
    bucket       = "tf-labs-state-juan"
    key          = "lambda_cleaner/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project = "Cleaner"
    }
  }
}
