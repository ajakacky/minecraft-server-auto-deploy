module "lambda_role" {
  source          = "../iam_role"
  iam_role_name   = var.iam_role_name
  principal       = { Service = ["lambda.amazonaws.com"] } 
  iam_policy_arns = var.iam_policies
  tags            = var.tags
}

data "archive_file" "lambda_file" {
  type        = "zip"
  source_dir  = "${var.lambda_file_path}/"
  output_path = local.lambda_filename
}

resource "aws_lambda_event_source_mapping" "event_source_mappings" {
  count            = length(var.event_source_arns)
  event_source_arn = var.event_source_arns[count.index]
  function_name    = aws_lambda_function.lambda.arn
  batch_size       = 1
  depends_on       = [aws_lambda_function.lambda]
}

resource "aws_lambda_permission" "invoke_model_permission" {
  count         = var.lambda_permission != {} ? 1 : 0
  statement_id  = var.lambda_permission.statement_id
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = var.lambda_permission.principal
  source_arn    = var.lambda_permission.source_arn
}

resource "aws_lambda_function" "lambda" {
  filename         = data.archive_file.lambda_file.output_path
  function_name    = var.function_name
  role             = module.lambda_role.arn
  handler          = var.handler
  source_code_hash = data.archive_file.lambda_file.output_base64sha256
  runtime          = var.runtime
  memory_size      = var.memory
  timeout          = var.timeout

  dynamic "environment" {
    for_each = local.environment_map
    content {
      variables = environment.value
    }
  }
}
