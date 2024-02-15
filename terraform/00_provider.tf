# Terraform Settings Block
terraform {
  # required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31"
    }
  }
}

# Terraform Provider Block
provider "aws" {
  profile = var.aws_profile
  region  = "ap-southeast-3"
}
