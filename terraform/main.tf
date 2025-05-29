provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

# ─────────────────────────────────────────
# MODULE: SSM Parameters
# ─────────────────────────────────────────
module "ssm_parameters" {
  source             = "./modules/ssm_parameters"
  github_oauth_token = var.github_oauth_token
  db_username        = var.db_username
  db_password        = var.db_password
}

# ─────────────────────────────────────────
# MODULE: Security Groups
# ─────────────────────────────────────────
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = var.vpc_id
}

# ─────────────────────────────────────────
# MODULE: RDS
# ─────────────────────────────────────────
module "rds" {
  source                    = "./modules/rds"
  db_username               = var.db_username
  db_password               = var.db_password
  vpc_id                    = var.vpc_id
  public_subnet_ids         = var.public_subnet_ids
  private_subnet_ids        = var.private_subnet_ids
  rds_sg_id                 = module.security_groups.rds_sg_id
  use_public_subnet_for_rds = var.use_public_subnet_for_rds
}

# ─────────────────────────────────────────
# MODULE: Lambda
# ─────────────────────────────────────────
module "lambda" {
  source               = "./modules/lambda"
  subnet_ids           = var.private_subnet_ids
  lambda_sg_id         = module.security_groups.lambda_sg_id
  db_host              = module.rds.rds_endpoint
  db_username          = var.db_username
  db_password          = var.db_password
  region               = var.region
  cognito_user_pool_id = ""  # Temporarily empty or provide if you want; cognito user pool not created yet
  cognito_client_id    = ""  # Same here
}

# ─────────────────────────────────────────
# MODULE: Cognito
# ─────────────────────────────────────────
module "cognito" {
  source                   = "./modules/cognito"
  user_migration_lambda_arn = module.lambda.user_migration_lambda_arn
}

# ─────────────────────────────────────────
# Fix the cognito outputs references after creation
# We can use output references for lambda module to update cognito module inputs if needed in more advanced setup

# ─────────────────────────────────────────
# MODULE: Lambda (update with Cognito info if needed)
# ─────────────────────────────────────────
# If your Lambda module depends on Cognito outputs (like user_pool_id), you need a two-step apply or move the lambda module after cognito:
# 
# module "lambda" {
#   source               = "./modules/lambda"
#   subnet_ids           = var.private_subnet_ids
#   lambda_sg_id         = module.security_groups.lambda_sg_id
#   db_host              = module.rds.rds_endpoint
#   db_username          = var.db_username
#   db_password          = var.db_password
#   region               = var.region
#   cognito_user_pool_id = module.cognito.user_pool_id
#   cognito_client_id    = module.cognito.user_pool_client_id
# }
#
# If you want to do this, remove the previous lambda block and keep this one.

# ─────────────────────────────────────────
# MODULE: CloudWatch (Log Groups & Dashboard)
# ─────────────────────────────────────────
module "cloudwatch" {
  source               = "./modules/cloudwatch"
  lambda_function_name = module.lambda.function_name
  rds_identifier       = module.rds.rds_identifier
  api_name             = "stockwishlist-api"
  region               = var.region
}

# ─────────────────────────────────────────
# MODULE: API Gateway
# ─────────────────────────────────────────
module "api_gateway" {
  source                = "./modules/api_gateway"
  lambda_invoke_arn     = module.lambda.lambda_arn
  cognito_user_pool_arn = module.cognito.user_pool_arn
  stage_name            = var.api_stage_name
  log_group_arn         = module.cloudwatch.api_log_group_arn
}

# ─────────────────────────────────────────
# MODULE: Amplify Frontend
# ─────────────────────────────────────────
module "amplify" {
  source               = "./modules/amplify"
  github_oauth_token   = var.github_oauth_token
  repository_url       = "https://github.com/RareSonal/StockWishlist"
  api_url              = module.api_gateway.api_url
  cognito_user_pool_id = module.cognito.user_pool_id
  cognito_client_id    = module.cognito.client_id
  region               = var.region
}
