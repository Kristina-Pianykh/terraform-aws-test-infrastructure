terraform {
  backend "s3" {
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  region                   = var.region
}
