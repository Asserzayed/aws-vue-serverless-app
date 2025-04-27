resource "aws_s3_bucket" "static_website" {
  bucket = "my-static-vue-website-${random_string.bucket_suffix.result}"
  tags = {
    Name        = "My Static Vue Website"
    Environment = "Production"
  }

  force_destroy = true
}

resource "aws_s3_bucket_versioning" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.bucket-policy.json
}

data "aws_iam_policy_document" "bucket-policy" {
  statement {
    sid    = "AllowPublicRead"
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.static_website.arn}",
      "${aws_s3_bucket.static_website.arn}/*",
    ]
    actions = ["S3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  depends_on = [aws_s3_bucket_public_access_block.static_website]
  # Ensure the bucket policy is applied after the public access block
}

resource "aws_s3_bucket_website_configuration" "static_website_config" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }
}

resource "random_string" "bucket_suffix" {
  length           = 8
  special          = false
  upper            = false
  lower            = true
  numeric          = true
  override_special = "_-"
  lifecycle {
    create_before_destroy = true # Ensure the resource is recreated before destroying the old one
  }

}

output "static-bucket-id" {
  value = aws_s3_bucket.static_website.id
  description = "The ID of the S3 bucket for the static website"
}
output "user-pool-id" {
  value = aws_cognito_user_pool.user_pool.id
  description = "The ID of the Cognito User Pool"
}
output "user-pool-client-id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
  description = "The ID of the Cognito User Pool Client"
}
output "api-url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
  description = "The URL of the API Gateway"
}
