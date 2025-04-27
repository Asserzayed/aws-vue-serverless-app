
output "cloudfront_distribution_id" {
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
