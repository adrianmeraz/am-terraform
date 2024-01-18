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