module minecraft_instance {
  source = "./modules/ec2-instance/"
  for_each      = local.deploy.instances
  name          = each.key
  subnet_id     = var.subnet_id
  vpc_id        = var.vpc_id
  instance_type = each.value.type
  key_name      = each.value.key_name
  user_data     = file(each.value.user_data)
  tags          = local.deploy.tags
}