terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.24.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "6.57.1"
    }
  }

  backend "s3" {
    bucket = "projects-infrastructure"
    key    = "homelab/terraform.tfstate"
    region = "eu-west-1"
  }

  required_version = ">= 1.11.0"
}

provider "cloudflare" {
  api_token = var.cloudflare.api_token
}

provider "aws" {
  region = local.aws_region
}
