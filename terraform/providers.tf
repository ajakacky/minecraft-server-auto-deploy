terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "remote" {
    region       = "us-east-1"
    # The name of your Terraform Cloud organization.
    organization = "minecraft-auto-deploy"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "minecraft-server-auto-deploy"
    }
  }
}