resource "aws_api_gateway_rest_api" "api" {
  name        = "stockwishlist-api"
  description = "API for Stock Wishlist"
}

# Root-level route /v1 (optional base group)
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "v1"
}

# ─────────────────────────────────────────────
# API Resources
# ─────────────────────────────────────────────

resource "aws_api_gateway_resource" "login" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "login"
}

resource "aws_api_gateway_resource" "stocks" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "stocks"
}

resource "aws_api_gateway_resource" "wishlist" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "wishlist"
}

# ─────────────────────────────────────────────
# Cognito Authorizer
# ─────────────────────────────────────────────

resource "aws_api_gateway_authorizer" "cognito_auth" {
  name            = "cognito-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.api.id
  identity_source = "method.request.header.Authorization"
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [var.cognito_user_pool_arn]
}

# ─────────────────────────────────────────────
# /v1 Methods (optional base route)
# ─────────────────────────────────────────────

locals {
  http_methods_auth = {
    GET    = "COGNITO_USER_POOLS"
    POST   = "COGNITO_USER_POOLS"
    PUT    = "NONE"
    DELETE = "NONE"
  }
}

resource "aws_api_gateway_method" "api_methods" {
  for_each      = local.http_methods_auth
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = each.key
  authorization = each.value
  authorizer_id = each.value == "COGNITO_USER_POOLS" ? aws_api_gateway_authorizer.cognito_auth.id : null
}

resource "aws_api_gateway_integration" "api_integrations" {
  for_each = aws_api_gateway_method.api_methods

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = each.key
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# ─────────────────────────────────────────────
# /login - POST
# ─────────────────────────────────────────────

resource "aws_api_gateway_method" "login_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.login.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "login_post" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.login.id
  http_method             = "POST"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# ─────────────────────────────────────────────
# /stocks - GET, POST, DELETE
# ─────────────────────────────────────────────

resource "aws_api_gateway_method" "stocks_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.stocks.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "stocks_get" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.stocks.id
  http_method             = "GET"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_method" "stocks_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.stocks.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "stocks_post" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.stocks.id
  http_method             = "POST"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_method" "stocks_delete" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.stocks.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "stocks_delete" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.stocks.id
  http_method             = "DELETE"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# ─────────────────────────────────────────────
# /wishlist - GET, POST, DELETE
# ─────────────────────────────────────────────

resource "aws_api_gateway_method" "wishlist_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.wishlist.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "wishlist_get" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.wishlist.id
  http_method             = "GET"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_method" "wishlist_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.wishlist.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "wishlist_post" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.wishlist.id
  http_method             = "POST"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_method" "wishlist_delete" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.wishlist.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "wishlist_delete" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.wishlist.id
  http_method             = "DELETE"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# ─────────────────────────────────────────────
# Deployment & Stage
# ─────────────────────────────────────────────

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_method.api_methods,
    aws_api_gateway_integration.api_integrations,

    aws_api_gateway_method.login_post,
    aws_api_gateway_integration.login_post,

    aws_api_gateway_method.stocks_get,
    aws_api_gateway_integration.stocks_get,
    aws_api_gateway_method.stocks_post,
    aws_api_gateway_integration.stocks_post,
    aws_api_gateway_method.stocks_delete,
    aws_api_gateway_integration.stocks_delete,

    aws_api_gateway_method.wishlist_get,
    aws_api_gateway_integration.wishlist_get,
    aws_api_gateway_method.wishlist_post,
    aws_api_gateway_integration.wishlist_post,
    aws_api_gateway_method.wishlist_delete,
    aws_api_gateway_integration.wishlist_delete,
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name   
