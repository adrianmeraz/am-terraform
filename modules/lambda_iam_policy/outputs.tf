output "arn" {
  description = "arn of the aws iam policy"
  value       = aws_iam_policy.lambda_iam_policy.arn
}
