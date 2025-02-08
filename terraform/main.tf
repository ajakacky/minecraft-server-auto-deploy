module minecraft_instance {
  source = "./modules/ec2-instance/"
  for_each        = local.deploy.instances
  name            = each.key
  subnet_id       = var.subnet_id
  vpc_id          = var.vpc_id
  instance_type   = each.value.type
  key_name        = each.value.key_name
  user_data       = templatefile(each.value.user_data, {
    cf_api_key = var.cf_api_key
  })
  admin_ips       = var.admin_ips
  member_ips      = var.member_ips
  ami_type        = "ubuntu"
  iam_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]
  tags            = local.deploy.tags
}

module iam_role {
  source          = "./modules/iam-role"
  iam_role_name   = "minecraft-api-role"
  iam_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]
  principal       = { Service = [ "ec2.amazonaws.com" ]} 
}