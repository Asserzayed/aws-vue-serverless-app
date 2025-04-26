resource "aws_cognito_user_pool" "user_pool" {
  name = "my_user_pool"
  auto_verified_attributes = ["email"]
  email_configuration {
      email_sending_account = "COGNITO_DEFAULT"
    }
  password_policy {
      minimum_length    = 8
      require_uppercase = true
      require_numbers   = true
      require_symbols   = true
      require_lowercase = true
    }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "my_user_pool_client"
  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false
  supported_identity_providers = ["COGNITO"]
  
  access_token_validity  = 1    # Hours
  id_token_validity     = 1    # Hours
  auth_session_validity = 15   # Minutes
  refresh_token_validity = 30  # Days

  token_validity_units {
    access_token  = "hours"
    id_token     = "hours"
    refresh_token = "days"
  }
}
