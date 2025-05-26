resource "aws_api_gateway_rest_api" "api" {
  name        = "stockwishlist-api"
  description = "API for Stock Wishlist"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "v1"
}

resource "aws_api_gateway_authorizer" "cognito_auth" {
  name            = "cognito-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.api.id
  identity_source = "method.request.header.Authorization"
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [var.cognito_user_pool_arn]
}

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

resource "aws_api_gateway_integration" "integrations" {
  for_each                = local.http_methods_auth
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = each.key
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.integrations]
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id

  access_log_settings {
    destination_arn = var.log_group_arn
    format = jsonencode({
      requestId       = "$context.requestId"
      ip              = "$context.identity.sourceIp"
      userAgent       = "$context.identity.userAgent"
      httpMethod      = "$context.httpMethod"
      resourcePath    = "$context.resourcePath"
      status          = "$context.status"
      responseLatency = "$context.responseLatency"
    })
  }

  method_settings {
    resource_path    = "/*"
    http_method      = "*"
    logging_level    = "INFO"
    metrics_enabled  = true
  }
}
