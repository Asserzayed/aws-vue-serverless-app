resource "aws_dynamodb_table" "wildrydes-dynamodb-table" {
  name         = "Rides"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "RideId"

  attribute {
    name = "RideId"
    type = "S"
  }

  tags = {
    Name        = "wildrydes-dynamodb-table"
    Environment = "production"
  }
}
