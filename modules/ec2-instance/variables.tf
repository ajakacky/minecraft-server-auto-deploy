variable tags          { default = {} }
variable ip_addresses  { default = {} }
variable ami_type      { default = "amazon-linux-2" }
variable admin_ips     { default = ["0.0.0.0/0"] }
variable member_ips    { default = ["0.0.0.0/0"] }
variable key_name      {}
variable user_data     {}
variable subnet_id     {}
variable vpc_id        {}
variable name          {}
variable instance_type {}

locals {
  security_group_name   = "security-group-${var.name}"
  iam_role_name         = "iam-role-${var.name}"
  iam_policy_name       = "iam-policy-${var.name}"
  instance_profile_name = "instance-profile-${var.name}"
  amis                  = {
    amazon-linux-2       = "ami-02e136e904f3da870"
    deep-learning-ubuntu = "ami-0e3c68b57d50caf64"
    ubuntu               = "ami-0747bdcabd34c712a"
  }
  rules = [
    {
      type              = "ingress"
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      cidr_blocks       = var.admin_ips
      security_group_id = aws_security_group.ec2_security_group.id
    },
    {
      type              = "ingress"
      from_port         = 25565
      to_port           = 25565
      protocol          = "tcp"
      cidr_blocks       = var.member_ips
      security_group_id = aws_security_group.ec2_security_group.id
    },
    {
      type              = "egress"
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      cidr_blocks       = var.admin_ips
      security_group_id = aws_security_group.ec2_security_group.id
    },
    {
      type              = "egress"
      from_port         = 25565
      to_port           = 25565
      protocol          = "tcp"
      cidr_blocks       = var.member_ips
      security_group_id = aws_security_group.ec2_security_group.id
    },
    {
      type              = "egress"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      security_group_id = aws_security_group.ec2_security_group.id
    }
  ]
}