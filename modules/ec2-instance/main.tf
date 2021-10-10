resource aws_security_group ec2_security_group {
  name        = local.security_group_name
  description = "Allow traffic for the Minecraft Server"
  vpc_id      = var.vpc_id

  tags = var.tags
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
  role = aws_iam_role.role.name
}

resource aws_iam_role role {
  name = local.iam_role_name
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource aws_iam_role_policy_attachment policy_attach {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource aws_iam_policy policy {
  name        = local.iam_policy_name
  path        = "/"
  description = "Policy to allow logs to go to cloudwatch"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = [
          "*"
        ]
      },
      {
        Sid = "IamPassRole",
        Effect = "Allow",
        Action = "iam:PassRole",
        Resource = "*",
        Condition = {
            StringEquals = {
                "iam:PassedToService" = "ec2.amazonaws.com"
            }
        }
      },
      {
        Sid = "ListEc2AndListInstanceProfiles",
        Effect = "Allow",
        Action = [
          "iam:ListInstanceProfiles",
          "ec2:Describe*",
          "ec2:Search*",
          "ec2:Get*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource aws_instance instance {
  ami                    = local.amis[var.ami_type]
  instance_type          = var.instance_type
  user_data              = var.user_data
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  vpc_security_group_ids = [ aws_security_group.ec2_security_group.id ]
  tags = var.tags
}