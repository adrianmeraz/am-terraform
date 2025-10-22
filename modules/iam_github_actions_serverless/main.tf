data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = [
        "apigateway.amazonaws.com",
        "cognito-idp.amazonaws.com",
        "lambda.amazonaws.com",
        "ssm.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "gha_serverless" {
  name               = "${var.name_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "main" {
  statement {
    sid = "ACM"
    actions = [
      "acm:DescribeCertificate",
      "acm:ListTagsForCertificate"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:acm:*:*:*"
    ]
  }

  statement {
    sid = "ApiGateway"
    actions = [
      "apigateway:GET",
      "apigateway:PATCH"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:apigateway:*:*:*"
    ]
  }

  statement {
    sid = "CostExplorer"
    actions = [
      "ce:ListCostAllocationTags"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:ce:*:*:*"
    ]
  }

  statement {
    sid = "CloudWatchLogs"
    actions = [
      "logs:DescribeLogGroups",
      "logs:ListTagsForResource"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }

  statement {
    sid = "Cognito"
    actions = [
      "cognito-idp:ListUserPools",
      "cognito-idp:ListUserPoolClients"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:cognito-idp:*:*:*"
    ]
  }

  statement {
    sid = "DynamoDb"
    actions = [
      "dynamodb:DescribeContinuousBackups",
      "dynamodb:DescribeTable",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:dynamodb:*:*:*"
    ]
  }

  statement {
    sid = "ECRPush"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetAccountSetting",
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:GetLifecyclePolicy",
      "ecr:ListTagsForResource",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:ecr:*:*:*"
    ]
  }

  statement {
    sid = "IAM"
    actions = [
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:iam:*:*:*"
    ]
  }

  statement {
    sid = "Lambda"
    actions = [
      "lambda:GetFunction",
      "lambda:GetPolicy",
      "lambda:ListVersionsByFunction",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:lambda:*:*:*"
    ]
  }

  statement {
    sid = "KMSReadOnly"
    actions = [
      "kms:Describe*",
      "kms:Get*",
      "kms:List*"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:kms:*:*:*"
    ]
  }

  statement {
    sid = "Route53"
    actions = [
      "route53:GetHostedZone",
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:route53:*:*:*"
    ]
  }

  statement {
    sid = "S3Buckets"
    actions = [
      "s3:GetObject",
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:PutObject"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:s3:*:*:*"
    ]
  }

  statement {
    sid = "SSMReadOnly"
    actions = [
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:ssm:*:*:*"
    ]
  }
}

resource "aws_iam_policy" "main" {
  name = "${var.name_prefix}-policy"
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.gha_serverless.name
  policy_arn = aws_iam_policy.main.arn
}
