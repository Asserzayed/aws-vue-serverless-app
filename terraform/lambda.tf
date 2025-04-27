data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/request_unicorn_function.zip"
}

resource "aws_lambda_function" "request_unicorn_function" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "request_unicorn_function.zip"
  function_name = "request_unicorn_function"
  role          = aws_iam_role.lambda-role.arn

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs18.x"
  handler = "index.handler"
}

resource "aws_iam_role" "lambda-role" {
  name               = "lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role-policy.json
}

data "aws_iam_policy_document" "lambda-assume-role-policy" {
  statement {
    effect  = "Allow"
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

