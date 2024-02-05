resource "aws_lambda_function" "main" {
  function_name = var.function_name
  handler       = var.handler
  image_uri     = var.image_uri
  package_type  = var.package_type
  role          = var.role
  runtime       = var.runtime

  tags = var.tags
}