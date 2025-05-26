resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/api_gateway/stockwishlist-api"
  retention_in_days = 14

  tags = {
    Name        = "API Gateway Logs"
    Environment = "dev"
  }
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14

  depends_on = [var.lambda_function_name]

  tags = {
    Name        = "Lambda Logs for Flask Backend"
    Environment = "dev"
  }
}

resource "aws_cloudwatch_dashboard" "stockwishlist_dashboard" {
  dashboard_name = "StockWishlistDashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x    = 0, y = 0,
        width = 12, height = 6,
        properties = {
          title   = "Lambda Duration",
          metrics = [["AWS/Lambda", "Duration", "FunctionName", var.lambda_function_name]],
          stat    = "Average", period = 300, region = var.region
        }
      },
      {
        type = "metric",
        x    = 12, y = 0,
        width = 12, height = 6,
        properties = {
          title   = "RDS CPU Utilization",
          metrics = [["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.rds_identifier]],
          stat    = "Average", period = 300, region = var.region
        }
      },
      {
        type = "metric",
        x    = 0, y = 6,
        width = 12, height = 6,
        properties = {
          title   = "API Latency",
          metrics = [["AWS/ApiGateway", "Latency", "ApiName", var.api_name]],
          stat    = "Average", period = 300, region = var.region
        }
      }
    ]
  })
}
