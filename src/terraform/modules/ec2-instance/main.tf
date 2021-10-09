resource aws_security_group ec2_security_group {
  name        = local.security_group_name
  description = "Allow traffic for the Minecraft Server"
  vpc_id      = var.vpc_id
  ingress     = [
    {
      description      = "Minecraft"
      from_port        = 25565
      to_port          = 25565
      protocol         = "tcp"
      cidr_blocks      = var.admin_ips
    },
    {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = var.member_ips
    }
  ]

  tags = var.tags
}

resource aws_instance instance {
  ami                    = local.amis[var.ami_type]
  instance_type          = var.instance_type
  user_data              = var.user_data
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [ aws_security_group.ec2_security_group.id ]

  tags = var.tags
}