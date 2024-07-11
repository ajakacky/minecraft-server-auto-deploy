variable "iam_role_name"      {}
variable "iam_policy_arns"    { default = [] }
variable "tags"               { default = {} }
variable "trust_relationship" { default = null }
variable "principal"          {}
variable "condition"          { default = null }
variable "iam_policies"       { default = {} }

locals {
	trust_relationship = var.trust_relationship == null ? (
		var.condition == null ?
		templatefile(
			"${path.module}/iam_role_policy.json.tpl",
			{ principal = jsonencode(var.principal) }
		) :
		templatefile(
			"${path.module}/iam_role_policy_condition.json.tpl",
			{ principal = jsonencode(var.principal), condition = jsonencode(var.condition) }
		)
	) : var.trust_relationship
}