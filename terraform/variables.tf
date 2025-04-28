variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "us-east-1"

}
variable "tfstate_bucket_name" {
  description = "The name of the S3 bucket to store the Terraform state file, necessary for github actions role"
  type        = string
  default     = "asser-terraform-state-bucket"
  # Override the default value with your own bucket name if needed
}
variable "organization_repo" {
  description = "The GitHub organization and repository name in the format 'owner/repo'"
  type        = string
  default     = "Asserzayed/aws-vue-serverless-app"
  # Override the default value with your own organization and repository name if needed
}
