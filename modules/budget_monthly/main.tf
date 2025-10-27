locals {
  name_prefix = "${var.name_prefix}-monthly-budget"
}

resource "aws_sns_topic" "monthly-budget" {
  name = "${local.name_prefix}-topic"
}

resource "aws_budgets_budget" "monthly" {
  name              = local.name_prefix
  budget_type       = "COST"
  limit_amount      = var.limit_amount
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_sns_topic_arns = [aws_sns_topic.monthly-budget.arn]
  }

  tags = var.tags
}