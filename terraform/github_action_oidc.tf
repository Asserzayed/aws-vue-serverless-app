resource "aws_iam_openid_connect_provider" "github_oidc_provider" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]
}
resource "aws_iam_role" "github-role" {
  name               = "github-role"
  assume_role_policy = data.aws_iam_policy_document.github-assume-role-policy.json
}

data "aws_iam_policy_document" "github-assume-role-policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_oidc_provider.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.organization_repo}:*"]
    }
  }
}

resource "aws_iam_role_policy" "github-s3-policy" {
  name   = "github-policy"
  role   = aws_iam_role.github-role.id
  policy = data.aws_iam_policy_document.github-s3-policy.json
}

data "aws_iam_policy_document" "github-s3-policy" {
  statement {
    effect = "Allow"
    actions = [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
    ]
    resources = [
      "${aws_s3_bucket.static_website.arn}",
      "${aws_s3_bucket.static_website.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "github-tfstate-policy" {
  name   = "github-tfstate-policy"
  role   = aws_iam_role.github-role.id
  policy = data.aws_iam_policy_document.github-tfstate-policy.json
}

data "aws_iam_policy_document" "github-tfstate-policy" {
  statement {
    effect = "Allow"
    actions = [
        "s3:GetObject",
    ]
    resources = [
      "${data.aws_s3_bucket.tfstate_bucket.arn}",
      "${data.aws_s3_bucket.tfstate_bucket.arn}/*",
    ]
  }
}

resource "aws_iam_role_policy" "github-cloudfront-policy" {
  name   = "github-cloudfront-policy"
  role   = aws_iam_role.github-role.id
  policy = data.aws_iam_policy_document.github-cloudfront-policy.json
}

data "aws_iam_policy_document" "github-cloudfront-policy" {
  statement {
    effect = "Allow"
    actions = [
        "cloudfront:CreateInvalidation",
        "cloudfront:GetDistribution",
        "cloudfront:UpdateDistribution",
    ]
    resources = [
      "${aws_cloudfront_distribution.cdn.arn}",
    ]
  }
  
}
