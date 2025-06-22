# ─────────────────────────────────────────────
# Create OPTIONS method (for CORS support)
# ─────────────────────────────────────────────
resource "aws_api_gateway_method" "options" {
  count         = var.create_options_method ? 1 : 0
  rest_api_id   = var.rest_api_id
  resource_id   = var.resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# ─────────────────────────────────────────────
# MOCK Integration for OPTIONS method
# ─────────────────────────────────────────────
resource "aws_api_gateway_integration" "options" {
  count                   = var.create_options_method ? 1 : 0
  rest_api_id             = var.rest_api_id
  resource_id             = var.resource_id
  http_method             = aws_api_gateway_method.options[count.index].http_method
  type                    = "MOCK"
  integration_http_method = "OPTIONS"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }

  depends_on = [aws_api_gateway_method.options]
}

# ─────────────────────────────────────────────
# Method Response for OPTIONS method
# ─────────────────────────────────────────────
resource "aws_api_gateway_method_response" "options" {
  count       = var.create_options_method ? 1 : 0
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.options[count.index].http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [aws_api_gateway_integration.options]
}

# ─────────────────────────────────────────────
# Integration Response for OPTIONS method
# ─────────────────────────────────────────────
resource "aws_api_gateway_integration_response" "options" {
  count       = var.create_options_method ? 1 : 0
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.options[count.index].http_method
  status_code = aws_api_gateway_method_response.options[count.index].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS,DELETE,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_method_response.options]
}
