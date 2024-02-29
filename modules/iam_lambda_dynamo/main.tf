data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "secretsmanager.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name_prefix        = var.name_prefix
  assume_role_policy = data.aws_iam_policy_document.lambda.json

  tags = var.tags
}

data "aws_iam_policy_document" "main" {
  statement {
    actions = [
      "ssm:GetParameters"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:ssm:*:*:*"
    ]
  }

  statement {
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:secretsmanager:*:*:*"
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }

  statement {
    actions = [
      "dynamodb:*"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:dynamodb:*:*:*"
    ]
  }
}

resource "aws_iam_policy" "main" {
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.main.arn
}

resource "aws_iam_role_policy_attachment" "lambda_handler_policy" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
