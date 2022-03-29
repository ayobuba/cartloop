
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.8.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.1.1"
    }
  }
}

provider "aws" {
  profile = "psirs-cloud-admin"
  region = "us-west-2"
}

provider "null" {}




