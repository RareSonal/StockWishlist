# ─────────────────────────────────────────────
# IAM Role & Policies
# ─────────────────────────────────────────────

resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy_attachment" "lambda_ssm" {
  name       = "lambda-ssm-policy-attachment"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_policy" "lambda_cloudwatch_policy" {
  name        = "lambda-cloudwatch-policy"
  description = "Allow Lambda to write logs to CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "logs:*",
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_cloudwatch_policy.arn
}

resource "aws_iam_policy" "lambda_cognito_policy" {
  name        = "lambda-cognito-policy"
  description = "Allow Lambda to interact with Cognito for user migration"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "cognito-idp:AdminCreateUser",
        "cognito-idp:AdminSetUserPassword",
        "cognito-idp:AdminAddUserToGroup",
        "cognito-idp:AdminInitiateAuth"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_cognito_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_cognito_policy.arn
}

# ─────────────────────────────────────────────
# Lambda Layer
# ─────────────────────────────────────────────

resource "aws_lambda_layer_version" "python_deps" {
  filename            = "${path.module}/build/python-deps-layer.zip"
  layer_name          = "python-deps-layer"
  compatible_runtimes = ["python3.12"]
  source_code_hash    = filebase64sha256("${path.module}/build/python-deps-layer.zip")
}

# ─────────────────────────────────────────────
# Lambda Archive Files
# ─────────────────────────────────────────────

data "archive_file" "flask_backend" {
  type        = "zip"
  source_dir  = "${path.module}/../../../backend/lambda_package"
  output_path = "${path.module}/build/function-code.zip"
}

data "archive_file" "user_migration" {
  type        = "zip"
  source_dir  = "${path.module}/../../../backend/user_migration"
  output_path = "${path.module}/build/user-migration.zip"
}

data "archive_file" "seed_db_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../../../backend/seed_db_lambda"
  output_path = "${path.module}/build/seed-db-lambda.zip"
}

# ─────────────────────────────────────────────
# Lambda Functions
# ─────────────────────────────────────────────

resource "aws_lambda_function" "flask_backend" {
  function_name = "flask-backend"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "server.handler"
  runtime       = "python3.12"
  filename      = data.archive_file.flask_backend.output_path
  source_code_hash = data.archive_file.flask_backend.output_base64sha256
  timeout       = 29
  memory_size   = 512
  layers        = [aws_lambda_layer_version.python_deps.arn]

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.lambda_sg_id]
  }

  environment {
    variables = {
      DB_HOST     = var.db_host
      DB_USER     = var.db_username
      DB_PASSWORD = var.db_password
      DB_NAME     = "stockwishlist"
      DB_PORT     = "5432"
    }
  }
}

resource "aws_lambda_function" "user_migration" {
  function_name = "user-migration-lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "user_migration.handler"
  runtime       = "python3.12"
  filename      = data.archive_file.user_migration.output_path
  source_code_hash = data.archive_file.user_migration.output_base64sha256
  timeout       = 30
  memory_size   = 512
  layers        = [aws_lambda_layer_version.python_deps.arn]

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.lambda_sg_id]
  }

  environment {
    variables = {
      DB_HOST     = var.db_host
      DB_USER     = var.db_username
      DB_PASSWORD = var.db_password
      DB_NAME     = "stockwishlist"
    }
  }
}

resource "aws_lambda_function" "seed_db_lambda" {
  function_name = "seed-db-lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "seed_db.handler"
  runtime       = "python3.12"
  filename      = data.archive_file.seed_db_lambda.output_path
  source_code_hash = data.archive_file.seed_db_lambda.output_base64sha256
  timeout       = 60
  memory_size   = 512
  layers        = [aws_lambda_layer_version.python_deps.arn]

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.lambda_sg_id]
  }

  environment {
    variables = {
      DB_HOST     = var.db_host
      DB_USER     = var.db_username
      DB_PASSWORD = var.db_password
      DB_NAME     = "stockwishlist"
    }
  }
}
