# Get current AWS account info
data "aws_caller_identity" "current" {}

# ────────────────────────────────
# REST API Definition
# ────────────────────────────────
resource "aws_api_gateway_rest_api" "api" {
  name        = "stockwishlist-api"
  description = "API for Stock Wishlist"
}

# ────────────────────────────────
# API Resources
# ────────────────────────────────
resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "v1"
}

resource "aws_api_gateway_resource" "v1_proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_resource" "login" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "login"
}

resource "aws_api_gateway_resource" "stocks" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "stocks"
}

resource "aws_api_gateway_resource" "wishlist" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "wishlist"
}

# ────────────────────────────────
# Cognito Authorizer
# ────────────────────────────────
resource "aws_api_gateway_authorizer" "cognito_auth" {
  name            = "cognito-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.api.id
  identity_source = "method.request.header.Authorization"
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [var.cognito_user_pool_arn]
}

# ────────────────────────────────
# Root GET method (no auth)
# ────────────────────────────────
resource "aws_api_gateway_method" "root_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_rest_api.api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root_get" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_rest_api.api.root_resource_id
  http_method             = aws_api_gateway_method.root_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# ────────────────────────────────
# /v1/{proxy+} ANY method (Cognito-protected)
# ────────────────────────────────
resource "aws_api_gateway_method" "any_proxy" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.v1_proxy.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "any_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.v1_proxy.id
  http_method             = aws_api_gateway_method.any_proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# ────────────────────────────────
# /v1/login POST (Public)
# ────────────────────────────────
resource "aws_api_gateway_method" "login_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.login.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "login_post" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.login.id
  http_method             = aws_api_gateway_method.login_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# ────────────────────────────────
# /v1/stocks - GET, POST (Cognito-protected)
# ────────────────────────────────
resource "aws_api_gateway_method" "stocks_methods" {
  for_each      = toset(["GET", "POST"])
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.stocks.id
  http_method   = each.key
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "stocks_integrations" {
  for_each                = aws_api_gateway_method.stocks_methods
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.stocks.id
  http_method             = each.value.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# ────────────────────────────────
# /v1/wishlist - GET, POST, DELETE (Cognito-protected)
# ────────────────────────────────
resource "aws_api_gateway_method" "wishlist_methods" {
  for_each      = toset(["GET", "POST", "DELETE"])
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.wishlist.id
  http_method   = each.key
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id
}

resource "aws_api_gateway_integration" "wishlist_integrations" {
  for_each                = aws_api_gateway_method.wishlist_methods
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.wishlist.id
  http_method             = each.value.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

────────────────────────────────
# Deployment & Stage
# ────────────────────────────────
resource "aws_api_gateway_deployment" "api_deployment" {
depends_on = [
  aws_api_gateway_method.root_get,
  aws_api_gateway_method.any_proxy,
  aws_api_gateway_method.login_post,
  aws_api_gateway_method.stocks_methods,
  aws_api_gateway_method.wishlist_methods,
  aws_api_gateway_integration.root_get,
  aws_api_gateway_integration.any_proxy,
  aws_api_gateway_integration.login_post,
  aws_api_gateway_integration.stocks_integrations,
  aws_api_gateway_integration.wishlist_integrations,
]


rest_api_id = aws_api_gateway_rest_api.api.id

triggers = {
  redeployment = sha1(jsonencode(flatten([
    aws_api_gateway_method.root_get.id,
    aws_api_gateway_integration.root_get.id,
    aws_api_gateway_method.any_proxy.id,
    aws_api_gateway_integration.any_proxy.id,
    aws_api_gateway_method.login_post.id,
    aws_api_gateway_integration.login_post.id,
    [for m in aws_api_gateway_method.stocks_methods : m.id],
    [for i in aws_api_gateway_integration.stocks_integrations : i.id],
    [for m in aws_api_gateway_method.wishlist_methods : m.id],
    [for i in aws_api_gateway_integration.wishlist_integrations : i.id],
    var.cors_trigger
  ])))
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.stage_name

  xray_tracing_enabled = true

  access_log_settings {
    destination_arn = var.log_group_arn
    format = jsonencode({
      requestId       = "$context.requestId",
      ip              = "$context.identity.sourceIp",
      caller          = "$context.identity.caller",
      user            = "$context.identity.user",
      requestTime     = "$context.requestTime",
      httpMethod      = "$context.httpMethod",
      resourcePath    = "$context.resourcePath",
      status          = "$context.status",
      protocol        = "$context.protocol",
      responseLength  = "$context.responseLength"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ────────────────────────────────
# Lambda Permission for API Gateway
# ────────────────────────────────
resource "aws_lambda_permission" "apigw_to_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/*/*"

  depends_on = [aws_api_gateway_rest_api.api]
}
