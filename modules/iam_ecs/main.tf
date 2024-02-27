data "aws_iam_policy_document" "ecs_tasks" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
        "secretsmanager.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs" {
  name_prefix        = var.name_prefix
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks.json

  tags = var.tags
}

data "aws_iam_policy_document" "ssm" {
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
}

resource "aws_iam_policy" "ssm" {
  policy = data.aws_iam_policy_document.ssm.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ecs.name
  policy_arn = aws_iam_policy.ssm.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
