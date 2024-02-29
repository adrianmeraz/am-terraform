# Creating S3 Buckets for tfstate files

```
aws s3api create-bucket --bucket CHANGE_ME --create-bucket-configuration LocationConstraint=us-west-2
```

# Initializing Terraform

Downloads Terraform AWS Providers and creates modules

Required before running Terraform for the first time

```
terraform init
```

# Running Plan

Scan for any changes required for your infrastructure.

Determines what needs to be created, updated, or destroyed to move from the real/current state of the infrastructure to the desired state.

```
terraform plan
```

# Apply Changes

Applies the changes real/current state of the infrastructure in order to achieve the desired state.

```
terraform apply
```
