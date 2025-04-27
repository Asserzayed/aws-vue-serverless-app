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

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for my static site"
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.static_website.id
  policy = data.aws_iam_policy_document.bucket-policy.json
}

data "aws_iam_policy_document" "bucket-policy" {
  statement {
    sid    = "AllowCloudFrontOAIAccess"
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.static_website.arn}",
      "${aws_s3_bucket.static_website.arn}/*",
    ]
    actions = ["S3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }

  depends_on = [aws_s3_bucket_public_access_block.static_website]
  # Ensure the bucket policy is applied after the public access block
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.static_website.bucket_regional_domain_name
    origin_id   = "s3-static-website"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-static-website"
    forwarded_values {
      query_string = true
      headers = ["Authorization", "Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]
      cookies {
        forward = "all"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    # Optionally add ACM certificate for custom domain
  }

  tags = {
    Project = "WildRydes"
  }
  depends_on = [ aws_cloudfront_origin_access_identity.oai ]
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
