resource "aws_lambda_function" "lambda_function" {
  tags = merge(
    tomap({
      "app_name": var.app_name
      "environment": var.environment
    }),
    var.tags,
  )
  function_name = "${var.environment}-${var.app_name}-${var.function_name}-lambda_function"
  role          = var.role
  handler       = var.handler
  runtime       = var.runtime
  image_uri     = var.image_uri
}