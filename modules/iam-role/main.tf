resource "aws_iam_role" "iam_role" {
	name               = var.iam_role_name
	path               = "/"
	description        = "Allows a service to interact with approved services"
	tags               = var.tags
	assume_role_policy = local.trust_relationship
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment_arns" {
	count      = length(var.iam_policy_arns)
	role       = var.iam_role_name
	policy_arn = var.iam_policy_arns[count.index]
	depends_on = [aws_iam_role.iam_role]
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment_names" {
	count      = length(var.iam_policies)
	role       = var.iam_role_name
	policy_arn = aws_iam_policy.policies[count.index].arn
	depends_on = [aws_iam_role.iam_role]
}

resource "aws_iam_policy" "policies" {
	count       = length(var.iam_policies)
	name        = var.iam_policies[count.index].name
	path        = "/"
	description = lookup(var.iam_policies[count.index], "description", "AWS IAM Role Terraform Module")
	policy      = var.iam_policies[count.index].policy_json
}