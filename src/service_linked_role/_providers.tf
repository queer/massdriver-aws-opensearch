terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    cache = {
      version = "~> 0.1.0"
      source  = "massdriver-cloud/cache"
    }
  }
}

provider "cache" {}

provider "aws" {
  region = var.network.specs.aws.region
  assume_role {
    role_arn    = var.aws_authentication.data.arn
    external_id = var.aws_authentication.data.external_id
  }
  default_tags {
    tags = var.md_metadata.default_tags
  }
}
