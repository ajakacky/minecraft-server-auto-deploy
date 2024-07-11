variable "region"            { default = "us-east-1" }
variable "handler"           { default = "main.lambda_handler" }
variable "lambda_permission" { default = {} }
variable "function_name"     {}
variable "iam_role_name"     {}
variable "lambda_file_path"  {}
variable "runtime"           { default = "python3.7" }
variable "timeout"           { default = 3 }
variable "memory"            { default = 128 }
variable "iam_policies"      { default = [] }
variable "tags"              { default = {} }
variable "event_source_arns" { default = [] }
variable "env_variables"     { default = null }
locals {
	environment_map = var.env_variables[*]
	lambda_filename = "./${var.function_name}.zip"
}