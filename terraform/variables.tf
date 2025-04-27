variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "us-east-1"

}
variable "tfstate_bucket_name" {
  description = "The name of the S3 bucket to store the Terraform state file"
  type        = string
  default     = "asser-terraform-state-bucket"
  # Override the default value with your own bucket name if needed
}
