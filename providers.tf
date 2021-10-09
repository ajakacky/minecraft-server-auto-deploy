provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

# terraform {
#   backend "s3" {
#     bucket = "terraform-minecraft-deploy-backend"
#     key    = "terraform/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "minecraft-auto-deploy"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "minecraft-server-auto-deploy"
    }
  }
}