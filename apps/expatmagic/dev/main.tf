#module  "ec2" {
#  source = "../modules/ec2"
#  ami           = "ami-04e914639d0cca79a"
#  instance_type = "t4g.nano"
#  tags = {
#    "Environment": "dev"
#  }
#}

module  "ecr" {
  name = "em-ecr"
  source = "../../../modules/ecr"
  environment = var.environment
  tags = {
    "app_name": var.app_name
    "environment": var.environment
  }
}

module "lambda_role" {
  source = "../../../modules/lambda_role"
  name = "em_lambda_role"
}

module "lambda_iam_policy" {
  source = "../../../modules/lambda_iam_policy"
  name = "aws_iam_policy_for_terraform_aws_lambda_role"
  path = "/"
  description = "AWS IAM Policy for managing aws lambda role"
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = module.lambda_role.name
  policy_arn  = module.lambda_iam_policy.arn
}
