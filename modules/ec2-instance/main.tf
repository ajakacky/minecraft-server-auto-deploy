resource aws_security_group ec2_security_group {
  name        = local.security_group_name
  description = "Allow traffic for the Minecraft Server"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource aws_security_group_rule rules {
  count             = length(local.rules)
  type              = local.rules[count.index].type
  from_port         = local.rules[count.index].from_port
  to_port           = local.rules[count.index].to_port
  protocol          = local.rules[count.index].protocol
  cidr_blocks       = local.rules[count.index].cidr_blocks
  security_group_id = local.rules[count.index].security_group_id
}

resource aws_iam_instance_profile profile {
  name = local.instance_profile_name
  role = local.iam_role_name
}

module iam_role {
  source          = "../iam-role"
  iam_role_name   = local.iam_role_name
  iam_policies    = [
    {
      name        = local.iam_policy_name
      policy_json = file("${path.module}/templates/ec2_policy.json")
    }
  ]
  iam_policy_arns = var.iam_policy_arns
  principal       = { Service = [ "ec2.amazonaws.com" ]} 
}

resource aws_instance instance {
  ami                    = local.amis[var.ami_type]
  instance_type          = var.instance_type
  user_data              = var.user_data
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  vpc_security_group_ids = [ aws_security_group.ec2_security_group.id ]
  tags                   = var.tags
}