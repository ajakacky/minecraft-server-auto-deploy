provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

module minecraft_instance {
  source = "./modules/ec2-instance/"
  
  name          = "minecraft-server"
  instance_type = ""
}