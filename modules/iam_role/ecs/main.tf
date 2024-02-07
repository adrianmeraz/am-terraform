# --- ECS Node Role ---
data "aws_iam_policy_document" "ecs" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
        "secretsmanager:GetSecretValue"
      ]
    }
  }
}

resource "aws_iam_role" "ecs" {
  name_prefix        = var.name
  assume_role_policy = data.aws_iam_policy_document.ecs.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_role_policy" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#resource "aws_iam_instance_profile" "ecs" {
#  name_prefix = var.name
#  path        = "/${var.name}/ecs/instance/"
#  role        = aws_iam_role.ecs.name
#
#  tags = var.tags
#}