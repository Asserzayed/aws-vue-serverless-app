resource "aws_dynamodb_table" "wildrydes-dynamodb-table" {
  name           = "Rides"
  billing_mode = "PAY_PER_REQUEST"
  hash_key       = "RideId"

  attribute {
    name = "RideId"
    type = "S"
  }

  tags = {
    Name        = "wildrydes-dynamodb-table"
    Environment = "production"
  }
}

resource "aws_iam_role" "lambda-role" {
  name               = "lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role-policy.json 
}

data "aws_iam_policy_document" "lambda-assume-role-policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "lambda-policy" {
  name   = "lambda-policy"
  role   = aws_iam_role.lambda-role.id
  policy = data.aws_iam_policy_document.lambda-policy.json
}

data "aws_iam_policy_document" "lambda-policy" {
    statement {
        effect = "Allow"
        actions = [
        "dynamodb:PutItem"
        ]
        resources = [aws_dynamodb_table.wildrydes-dynamodb-table.arn]
    } 
}
