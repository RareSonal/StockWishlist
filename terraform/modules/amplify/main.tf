resource "aws_amplify_app" "frontend" {
  name       = "stockwishlist-frontend"
  repository = var.repository_url
  oauth_token = var.github_oauth_token

  environment_variables = {
    AWS_REGION              = var.region
    VUE_APP_API_URL         = var.api_url
    VUE_APP_COGNITO_POOL_ID = var.cognito_user_pool_id
    VUE_APP_COGNITO_CLIENT_ID = var.cognito_client_id
    VUE_APP_COGNITO_REGION  = var.region
  }

  build_spec = <<-EOT
    version: 1.0
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn build
      artifacts:
        baseDirectory: /build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT
}
