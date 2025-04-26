data "archive_file" "lambda" {
  type        = "zip"
  source_file = "index.js"
  output_path = "request_unicorn_function.zip"
}

resource "aws_lambda_function" "request_unicorn_function" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "request_unicorn_function.zip"
  function_name = "request_unicorn_function"
  role          = aws_iam_role.lambda-role.arn

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs16.x"
  handler = "index.handler"
}
