resource "aws_lambda_function" "this" {
  tags = merge(
    tomap({
      "app_name": var.app_name
      "environment": var.environment
    }),
    var.tags,
  )
  function_name = "${var.app_name}_${var.environment}_${var.function_name}"
  handler       = var.handler
  image_uri     = var.image_uri
  package_type  = var.package_type
  role          = var.role
  runtime       = var.runtime
  snap_start    = var.snap_start
}