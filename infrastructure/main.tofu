terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.25.0"
    }
    keycloak = {
      source  = "keycloak/keycloak"
      version = "5.9.0"
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

provider "keycloak" {
  client_id     = "tofu"
  client_secret = var.keycloak.client_secret
  url           = var.keycloak.url
}