provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

module minecraft_instance {
  source = "./modules/ec2-instance/"
  for_each      = local.deploy.instances
  name          = each.key
  instance_type = each.value.type
  key_name      = each.value.key_name
  user_data     = file(each.value.user_data)
}