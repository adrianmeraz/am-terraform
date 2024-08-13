## Configure AWS Profile

Run the following command with the profile noted in the backend:

```
aws configure --profile CHANGE_ME
```

For example, if the backend specifies this:

```
backend "s3" {
    profile = "anotherapp"
}
```

The following profile must be configured:


```
aws configure --profile anotherapp
```

Then, fill in the AWS secret id, secret key, and region.

## Creating S3 Buckets for tfstate files

Use only one bucket per environment for ALL apps.

Use a different key for each app to differentiate state files.

```
aws s3api create-bucket --bucket CHANGE_ME --create-bucket-configuration LocationConstraint=us-west-2
```

## General Workflow

1. Startup Docker Desktop engine or ecr commands will fail
2. For a given app or group of apps, run any shared main modules under the ```_shared``` folder first. 
   1. Resources like Cognito User pools and shared secrets need to be initialized prior to apps.

2. Do a ```cd``` to a given app and environment. Then the commands below can be run.

## Initializing Terraform

Downloads Terraform AWS Providers and creates modules

Required before running Terraform for the first time

```
terraform init
```

## Running Plan

Scan for any changes required for your infrastructure.

Determines what needs to be created, updated, or destroyed to move from the real/current state of the infrastructure to the desired state.

```
terraform plan
```

## Apply Changes

Applies the changes real/current state of the infrastructure in order to achieve the desired state.

```
terraform apply
```

