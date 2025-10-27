resource "aws_iam_openid_connect_provider" "main" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  # The thumbprint is mandatory, set it to fff as suggested by github
  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
}

data "aws_iam_policy_document" "oidc" {
  statement {
    sid = "GithubOIDC"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    effect = "Allow"

    principals {
      type = "Federated"
      identifiers = [aws_iam_openid_connect_provider.main.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = ["repo:${var.github_org}/${var.github_repository}:*"]
    }
  }
}

resource "aws_iam_role" "gha_oidc_serverless" {
  name               = "${var.name_prefix}-gha-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.oidc.json

  tags = var.tags
}

data "aws_iam_policy_document" "main" {
  statement {
    sid     = "ACM"
    actions = [
      "acm:Describe*",
      "acm:List*"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:acm:*:*:*"
    ]
  }

  statement {
    sid     = "ApiGateway"
    actions = [
      "apigateway:*",
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:apigateway:*:*:*"
    ]
  }

  statement {
    sid     = "Budgets"
    actions = [
      "budgets:View*"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:budgets:*:*:*"
    ]
  }

  statement {
    sid     = "CostExplorer"
    actions = [
      "ce:List*"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:ce:*:*:*"
    ]
  }

  statement {
    sid     = "CloudWatchLogs"
    actions = [
      "logs:Describe*",
      "logs:List*"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }

  statement {
    sid     = "Cognito"
    actions = [
      "cognito-idp:List*",
    ]
    effect    = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    sid     = "DynamoDb"
    actions = [
      "dynamodb:Describe*",
      "dynamodb:ListTagsOfResource"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:dynamodb:*:*:*"
    ]
  }

  statement {
    sid     = "ECRAllowPushPull"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:InitiateLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetLifecyclePolicy",
      "ecr:ListTagsForResource",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:ecr:*:*:*"
    ]
  }

  statement {
    sid     = "ECRAuth"
    actions = [
      "ecr:GetAccountSetting",
      "ecr:GetAuthorizationToken"
    ]
    effect    = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    sid     = "IAM"
    actions = [
      "iam:Get*",
      "iam:List*",
    ]
    effect    = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    sid     = "Lambda"
    actions = [
      "lambda:Get*",
      "lambda:List*",
      "lambda:Update*",
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:lambda:*:*:*"
    ]
  }

  statement {
    sid     = "KMSReadOnly"
    actions = [
      "kms:Describe*",
      "kms:Get*",
      "kms:List*"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:kms:*:*:*"
    ]
  }

  statement {
    sid     = "Route53"
    actions = [
      "route53:Get*",
      "route53:List*",
    ]
    effect    = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    sid     = "S3Buckets"
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:PutObject"
    ]
    effect    = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    sid     = "SNS"
    actions = [
      "SNS:Get*",
      "SNS:List*",
      "SNS:Publish",
      "SNS:SetTopicAttributes"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:sns:*:*:*"
    ]
  }

  statement {
    sid     = "SSMReadOnly"
    actions = [
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:ssm:*:*:*"
    ]
  }
}

resource "aws_iam_policy" "gha" {
  name = "${var.name_prefix}-gha-policy"
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role_policy_attachment" "gha" {
  role       = aws_iam_role.gha_oidc_serverless.name
  policy_arn = aws_iam_policy.gha.arn
}
