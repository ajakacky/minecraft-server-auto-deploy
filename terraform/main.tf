module minecraft_instance {
  source = "./modules/ec2-instance/"
  for_each        = local.deploy.instances
  name            = each.key
  subnet_id       = var.subnet_id
  vpc_id          = var.vpc_id
  instance_type   = each.value.type
  key_name        = each.value.key_name
  user_data       = file(each.value.user_data)
  admin_ips       = var.admin_ips
  member_ips      = var.member_ips
  ami_type        = "ubuntu"
  iam_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]
  tags            = local.deploy.tags
}