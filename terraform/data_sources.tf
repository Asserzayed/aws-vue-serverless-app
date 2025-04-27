data "aws_s3_bucket" "tfstate_bucket" {
    bucket = var.tfstate_bucket_name
    # This data source retrieves the S3 bucket information for the Terraform state file.
}

data "aws_caller_identity" "current" {}
    # This data source retrieves the AWS account ID and other information about the current IAM user or role.
    # It is used to get the account ID for use in IAM policies and other resources.
    # The account ID is used to specify the principal in the IAM policy document for the GitHub OIDC provider.
    # The region is also specified to ensure that the data source is queried in the correct AWS region.
    # This is important for ensuring that the resources are created in the correct region and that the IAM policies are applied correctly.
