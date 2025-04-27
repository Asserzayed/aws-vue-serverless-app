variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "us-east-1"

}
variable "accountId" {
  type        = string
  description = "The AWS account ID"
  default     = ""
}
