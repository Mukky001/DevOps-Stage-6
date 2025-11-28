terraform {
  # We strictly require the AWS provider
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Ensure we use a stable Terraform version
  required_version = ">= 1.2.0"
}

# Configure the AWS Provider
provider "aws" {
  region = var.region # We will define this variable next
}
