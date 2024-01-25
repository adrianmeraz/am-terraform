resource "aws_iam_policy" "lambda_iam_policy" {
  name         = "${var.environment}-${var.name}-lambda_iam_policy"
  tags = merge(
    tomap({
      "app_name": var.app_name
      "environment": var.environment
    }),
    var.tags,
  )
  path         = var.path
  description  = var.description
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
