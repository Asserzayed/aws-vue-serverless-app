resource "aws_s3_bucket" "state_bucket" {
  bucket = "my-tfstate-bucket"
  lifecycle {
    prevent_destroy = true
  }
}
