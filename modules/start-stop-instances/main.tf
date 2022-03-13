resource aws_iam_policy policy {
  name        = local.iam_policy_name
  path        = "/"
  description = "Policy to allow logs to go to cloudwatch"
  policy      = jsonencode(file("${path.module}/templates/ec2_policy.tpl"))
}

resource aws_cloudwatch_event_rule turn_on {
  name                = local.cloudwatch_rule_name
  description         = "Turn on EC2 Instance"
  schedule_expression = local.cron_startup
}

resource aws_cloudwatch_event_rule turn_off {
  name                = local.cloudwatch_rule_name
  description         = "Turn off EC2 Instance"
  schedule_expression = local.cron_shutdown
}

resource aws_cloudwatch_event_rule ebs_backup {
  name                = local.cloudwatch_rule_name
  description         = "Capture each AWS Console Sign In"
  schedule_expression = "cron(0 20 * * ? *)"
}

resource aws_cloudwatch_event_target stop_instance {
  target_id = "StopInstance"
  arn       = module.stop_instance.arn
  rule      = aws_cloudwatch_event_rule.turn_off.name
  role_arn  = aws_iam_role.ssm_lifecycle.arn
}

resource aws_cloudwatch_event_target start_instance {
  target_id = "StartInstance"
  arn       = module.start_instance.arn
  rule      = aws_cloudwatch_event_rule.turn_on.name
  role_arn  = aws_iam_role.ssm_lifecycle.arn
}

resource "aws_cloudwatch_event_rule" "snapshot_example" {
  name = "example-snapshot-volumes"
  description = "Snapshot EBS volumes"
  schedule_expression = "rate(24 hours)"
}

resource "aws_cloudwatch_event_target" "example_event_target" {
  target_id = "example"
  rule = "${aws_cloudwatch_event_rule.snapshot_example.name}"
  arn = "arn:aws:automation:${var.aws_region}:${var.account_id}:action/EBSCreateSnapshot/EBSCreateSnapshot_example-snapshot-volumes"
  input = "${jsonencode("arn:aws:ec2:${var.aws_region}:${var.account_id}:volume/${aws_ebs_volume.example.id}")}"
}

resource "aws_iam_role" "snapshot_permissions" {
  name = "example"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "automation.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "snapshot_policy" {
    name        = "example-snapshot-policy"
    description = "grant ebs snapshot permissions to cloudwatch event rule"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ec2:RebootInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances",
        "ec2:CreateSnapshot"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "snapshot_policy_attach" {
    role       = "${aws_iam_role.snapshot_permissions.name}"
    policy_arn = "${aws_iam_policy.snapshot_policy.arn}"
}

resource aws_cloudwatch_event_target create_snapshot {
  target_id = "CreateSnapshot"
  arn       = module.start_instance.arn
  rule      = aws_cloudwatch_event_rule.turn_on.name
  role_arn  = aws_iam_role.ssm_lifecycle.arn
}

module stop_instance {
  source            = "./modules/lambda_function"
  function_name     = "lambda-stop-instance-${var.name}"
  lambda_file_path  = "${path.module}/lambdas/stop_ec2"
  iam_role_name     = "role-stop-instance-${var.name}"
  iam_policies      = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

module start_instance {
  source            = "./modules/lambda_function"
  function_name     = "lambda-start-instance-${var.name}"
  lambda_file_path  = "${path.module}/lambdas/start_ec2"
  iam_role_name     = "role-start-instance-${var.name}"
  iam_policies      = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}