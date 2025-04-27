output "cloudfront-distribution-id" {
  value       = aws_cloudfront_distribution.cdn.domain_name
  description = "The ID of the CloudFront distribution"
}

output "static-bucket-id" {
  value       = aws_s3_bucket.static_website.id
  description = "The ID of the S3 bucket for the static website"
}
output "user-pool-id" {
  value       = aws_cognito_user_pool.user_pool.id
  description = "The ID of the Cognito User Pool"
}
output "user-pool-client-id" {
  value       = aws_cognito_user_pool_client.user_pool_client.id
  description = "The ID of the Cognito User Pool Client"
}
output "api-url" {
  value       = aws_api_gateway_stage.prod_stage.invoke_url
  description = "The URL of the API Gateway"
}
output "github-iam-role-arn" {
  value = aws_iam_role.github-role.arn
  description = "The ARN of the IAM role for GitHub Actions"
}

output "state-bucket-id" {
  value       = data.aws_s3_bucket.tfstate_bucket.bucket
  description = "The name of the S3 bucket for Terraform state"
}
