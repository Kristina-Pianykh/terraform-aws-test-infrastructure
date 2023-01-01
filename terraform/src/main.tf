terraform {
  backend "s3" {
    bucket = "tf-demo-storage"
    key    = "terraform-demo/terraform.tfstate"
    region = "eu-west-1"
  }
  required_providers {
    aws = {
      source  =                       "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  region                   = var.region
}
