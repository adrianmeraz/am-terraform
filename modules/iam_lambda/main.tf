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

data "aws_iam_policy_document" "ssm" {
    statement {
      actions = [
        "ssm:GetParameters"
      ]
      effect  = "Allow"
      resources = [
        "*"
      ]
    }

    statement {
      actions = [
        "secretsmanager:DescribeSecret",
        "secretsmanager:GetSecretValue",
      ]
      effect  = "Allow"
      resources = [
        "*"
      ]
    }
}

resource "aws_iam_policy" "ssm" {
  policy = data.aws_iam_policy_document.ssm.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.ssm.arn
}
