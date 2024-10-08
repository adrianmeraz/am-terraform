resource "aws_api_gateway_account" "main" {
  cloudwatch_role_arn = var.cloudwatch_role_arn
}

resource "aws_api_gateway_rest_api" "http" {
  name = "${var.name_prefix}-apigw"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

resource "aws_api_gateway_authorizer" "cognito" {
  name          = "${var.name_prefix}-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.http.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [var.cognito_pool_arn]
}

module "apigw_integration" {
  depends_on  = [
    aws_api_gateway_rest_api.http,
  ]

  source = "../apigw_lambda_integration"

  for_each                   = {for index, cfg in var.lambda_configs: cfg.function_name => cfg}

  cognito_authorizer_id      = aws_api_gateway_authorizer.cognito.id
  http_method                = each.value.http_method
  is_protected               = each.value.is_protected
  name_prefix                = var.name_prefix
  lambda_function_invoke_arn = each.value.invoke_arn
  lambda_function_name       = each.value.function_name
  path_part                  = each.value.path_part
  rest_api_execution_arn     = aws_api_gateway_rest_api.http.execution_arn
  rest_api_id                = aws_api_gateway_rest_api.http.id
  root_resource_id           = aws_api_gateway_rest_api.http.root_resource_id
}

resource "aws_api_gateway_deployment" "main" {
  depends_on = [module.apigw_integration]

  stage_description = md5(file("main.tf")) # Forces redeployment of stage upon any change to apigw per https://github.com/hashicorp/terraform/issues/6613#issuecomment-322264393
  rest_api_id       = aws_api_gateway_rest_api.http.id
  # Solves bug with "creating API Gateway Stage (dev): ConflictException: Stage already exists" per https://github.com/hashicorp/terraform-provider-aws/issues/1153#issuecomment-505358799
  # Hint: New lambda endpoints may not add correctly to the stage.
  # To force redeploy stage, change name, apply, and set it back to ""
  stage_name        = ""

  # Fix for: deleting API Gateway Deployment (abcdef): BadRequestException: Active stages pointing to this deployment must be moved or deleted
  # Per https://github.com/hashicorp/terraform/issues/10674#issuecomment-290767062
  lifecycle {
    create_before_destroy = true
  }
}

# Set a default stage
resource "aws_api_gateway_stage" "default" {
  depends_on  = [
    aws_api_gateway_deployment.main,
    aws_api_gateway_rest_api.http
  ]
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.http.id
  stage_name    = var.environment
  access_log_settings {
    destination_arn = var.cloudwatch_log_group_arn
    # Format taken from here: https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html
    format          = jsonencode(
      {
        requestId         = "$context.requestId"
        extendedRequestId = "$context.extendedRequestId"
        caller            = "$context.identity.caller"
        httpMethod        = "$context.httpMethod"
        ip                = "$context.identity.sourceIp"
        protocol          = "$context.protocol"
        requestTime       = "$context.requestTime"
        resourcePath      = "$context.resourcePath"
        responseLength    = "$context.responseLength"
        status            = "$context.status"
        user              = "$context.identity.user"
      }
    )
  }

  tags = var.tags
}

resource "aws_api_gateway_method_settings" "main" {
  depends_on  = [aws_api_gateway_deployment.main]
  rest_api_id = aws_api_gateway_rest_api.http.id
  stage_name  = aws_api_gateway_stage.default.stage_name
  method_path = "*/*"
  settings {
    logging_level = "INFO"
    data_trace_enabled = true
    metrics_enabled = true
  }
}