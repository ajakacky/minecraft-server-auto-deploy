resource aws_security_group ec2_security_group {
  name        = local.security_group_name
  description = "Allow traffic for the Minecraft Server"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource aws_security_group_rule minecraft {
  type              = "ingress"
  from_port         = 25565
  to_port           = 25565
  protocol          = "tcp"
  cidr_blocks       = var.member_ips
  security_group_id = aws_security_group.ec2_security_group.id
}

resource aws_security_group_rule ssh {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.admin_ips
  security_group_id = aws_security_group.ec2_security_group.id
}

resource aws_instance instance {
  ami                    = local.amis[var.ami_type]
  instance_type          = var.instance_type
  user_data              = var.user_data
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [ aws_security_group.ec2_security_group.id ]
  tags = var.tags
}