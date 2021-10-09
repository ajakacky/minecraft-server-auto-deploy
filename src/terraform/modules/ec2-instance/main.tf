resource "aws_vpc" "vpc" {
  cidr_block = "172.16.0.0/16"

  tags = var.tags
}

resource aws_security_group ec2_security_group {
  name        = local.security_group_name
  description = "Allow traffic for the Minecraft Server"
  vpc_id      = var.vpc_id#aws_vpc.vpc.id

  ingress = [
    {
      description      = "Minecraft"
      from_port        = 25565
      to_port          = 25565
      protocol         = "tcp"
      cidr_blocks      = var.admin_ips#["192.168.1.48/32"]
    },
    {
      description      = "ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = var.member_ips#["192.168.1.48/32"]
    }
  ]

  tags = var.tags
}

resource aws_instance instance {
  ami           = local.amis[var.ami_type]
  instance_type = var.instance_type
  user_data     = var.user_data

  tags = var.tags
}