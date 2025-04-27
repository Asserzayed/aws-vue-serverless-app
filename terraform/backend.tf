terraform {
  backend "s3" {
    bucket       = "asser-terraform-state-bucket"
    key          = "terraform/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true # Enable server-side encryption
    use_lockfile = true # Enable state locking
  }
}
