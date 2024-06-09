# ========================================== #
# Terraform Configuration
# ========================================== #
terraform {
  required_version = ">= 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# ========================================== #
# Provider
# ========================================== #
provider "aws" {
  profile = var.profile
  region  = var.region
}