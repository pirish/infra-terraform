## This file should be overwritten by terragrunt. Added to pass linting.

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      version = "~> 5"
      source  = "hashicorp/aws"
    }
  }
}
