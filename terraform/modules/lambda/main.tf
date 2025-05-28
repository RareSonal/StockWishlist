resource "aws_iam_role" "lambda_exec" {
name = "lambda-exec-role"

assume_role_policy = jsonencode({
Version = "2012-10-17",
Statement = [{
Effect = "Allow",
Principal = {
Service = "lambda.amazonaws.com"
},
Action = "sts:AssumeRole"
}]
})
}

# Attach basic execution permissions
resource "aws_iam_role_policy_attachment" "lambda_logging" {
role = aws_iam_role.lambda_exec.name
policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach SSM read-only permissions
resource "aws_iam_policy_attachment" "lambda_ssm" {
name = "lambda-ssm-policy-attachment"
roles = [aws_iam_role.lambda_exec.name]
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

# Allow Lambda to write logs to CloudWatch
resource "aws_iam_policy" "lambda_cloudwatch_policy" {
name = "lambda-cloudwatch-policy"
description = "Allow Lambda to write logs to CloudWatch"

policy = jsonencode({
Version = "2012-10-17",
Statement = [{
Effect = "Allow",
Action = "logs:*",
Resource = "*"
}]
})
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_policy_attachment" {
role = aws_iam_role.lambda_exec.name
policy_arn = aws_iam_policy.lambda_cloudwatch_policy.arn
}

# Allow Lambda to perform Cognito user migration
resource "aws_iam_policy" "lambda_cognito_policy" {
name = "lambda-cognito-policy"
description = "Allow Lambda to interact with Cognito for user migration"

policy = jsonencode({
Version = "2012-10-17",
Statement = [
{
Effect = "Allow",
Action = [
"cognito-idp:AdminCreateUser",
"cognito-idp:AdminSetUserPassword",
"cognito-idp:AdminAddUserToGroup",
"cognito-idp:AdminInitiateAuth"
],
Resource = "*"
}
]
})
}

resource "aws_iam_role_policy_attachment" "lambda_cognito_policy_attachment" {
role = aws_iam_role.lambda_exec.name
policy_arn = aws_iam_policy.lambda_cognito_policy.arn
}

# Python layer for dependencies
resource "aws_lambda_layer_version" "python_deps" {
filename = "${path.module}/build/python-deps-layer.zip"
layer_name = "python-deps-layer"
compatible_runtimes = ["python3.12"]
}

# Backend Lambda
resource "aws_lambda_function" "flask_backend" {
function_name = "flask-backend"
role = aws_iam_role.lambda_exec.arn
handler = "server.handler"
runtime = "python3.12"
filename = "${path.module}/build/function-code.zip"
source_code_hash = filebase64sha256("${path.module}/build/function-code.zip")
timeout = 29
memory_size = 512

layers = [aws_lambda_layer_version.python_deps.arn]

vpc_config {
subnet_ids = var.subnet_ids
security_group_ids = [var.lambda_sg_id]
}

environment {
variables = {
DB_HOST = var.db_host
DB_USER = var.db_username
DB_PASSWORD = var.db_password
DB_NAME = "stockwishlist"
DB_PORT = "5432"
COGNITO_USER_POOL_ID = var.cognito_user_pool_id
COGNITO_REGION = var.region
COGNITO_APP_CLIENT_ID = var.cognito_client_id
}
}
}

# User Migration Lambda
resource "aws_lambda_function" "user_migration" {
function_name = "user-migration-lambda"
role = aws_iam_role.lambda_exec.arn
handler = "user_migration.handler"
runtime = "python3.12"
filename = "${path.module}/build/user-migration.zip"
source_code_hash = filebase64sha256("${path.module}/build/user-migration.zip")
timeout = 30
memory_size = 512

vpc_config {
subnet_ids = var.subnet_ids
security_group_ids = [var.lambda_sg_id]
}

environment {
variables = {
DB_HOST = var.db_host
DB_USER = var.db_username
DB_PASSWORD = var.db_password
DB_NAME = "stockwishlist"
COGNITO_USER_POOL_ID = var.cognito_user_pool_id
COGNITO_REGION = var.region
}
}
}

# Allow Cognito to invoke the migration Lambda
resource "aws_lambda_permission" "allow_cognito_invoke" {
statement_id = "AllowExecutionFromCognito"
action = "lambda:InvokeFunction"
function_name = aws_lambda_function.user_migration.function_name
principal = "cognito-idp.amazonaws.com"
source_arn = var.cognito_user_pool_arn
}
