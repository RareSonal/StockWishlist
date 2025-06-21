provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

# ─────────────────────────────────────────────
# SYSTEM CONFIGURATION MODULES
# ─────────────────────────────────────────────
module "ssm_parameters" {
  source             = "./modules/ssm_parameters"
  github_oauth_token = var.github_oauth_token
  db_username        = var.db_username
  db_password        = var.db_password
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = var.vpc_id
}

# ─────────────────────────────────────────────
# DATABASE MODULE
# ─────────────────────────────────────────────
module "rds" {
  source                  = "./modules/rds"
  db_username             = var.db_username
  db_password             = var.db_password
  public_subnet_ids       = var.public_subnet_ids
  security_group_id       = module.security_groups.rds_sg_id
  use_public_subnet_for_rds = var.use_public_subnet_for_rds
}

# ─────────────────────────────────────────────
# BACKEND: LAMBDA MODULE
# ─────────────────────────────────────────────
module "lambda" {
  source         = "./modules/lambda"
  subnet_ids     = var.public_subnet_ids
  lambda_sg_id   = module.security_groups.lambda_sg_id
  db_host        = module.rds.endpoint
  db_username    = var.db_username
  db_password    = var.db_password
  db_name        = var.db_name
  db_port        = var.db_port
  region         = var.region
}

# ─────────────────────────────────────────────
# AUTHENTICATION: COGNITO MODULE
# ─────────────────────────────────────────────
module "cognito" {
  source                    = "./modules/cognito"
  user_migration_lambda_arn = module.lambda.user_migration_lambda_arn
  region                    = var.region
}

# ─────────────────────────────────────────────
# MONITORING: CLOUDWATCH MODULE
# ─────────────────────────────────────────────
module "cloudwatch" {
  source              = "./modules/cloudwatch"
  lambda_function_name = module.lambda.lambda_function_name
  rds_identifier       = module.rds.rds_identifier
  api_name             = "stockwishlist-api"
  region               = var.region
}

# ─────────────────────────────────────────────
# CORS CONFIGURATION MODULES
# ─────────────────────────────────────────────
module "cors_root" {
  source               = "./modules/cors"
  rest_api_id          = module.api_gateway.api_id
  resource_id          = module.api_gateway.root_resource_id
  create_options_method = true
  depends_on           = [module.api_gateway]
}

module "cors_v1_proxy" {
  source               = "./modules/cors"
  rest_api_id          = module.api_gateway.api_id
  resource_id          = module.api_gateway.proxy_resource_id
  create_options_method = true
  depends_on           = [module.api_gateway]
}

module "cors_login" {
  source               = "./modules/cors"
  rest_api_id          = module.api_gateway.api_id
  resource_id          = module.api_gateway.login_resource_id
  create_options_method = true
  depends_on           = [module.api_gateway]
}

module "cors_stocks" {
  source               = "./modules/cors"
  rest_api_id          = module.api_gateway.api_id
  resource_id          = module.api_gateway.stocks_resource_id
  create_options_method = true
  depends_on           = [module.api_gateway]
}

module "cors_wishlist" {
  source               = "./modules/cors"
  rest_api_id          = module.api_gateway.api_id
  resource_id          = module.api_gateway.wishlist_resource_id
  create_options_method = true
  depends_on           = [module.api_gateway]
}

# ─────────────────────────────────────────────
# API GATEWAY MODULE
# ─────────────────────────────────────────────
module "api_gateway" {
  source                = "./modules/api_gateway"
  lambda_invoke_arn     = module.lambda.lambda_invoke_arn
  lambda_function_name  = module.lambda.lambda_function_name
  cognito_user_pool_arn = module.cognito.user_pool_arn
  stage_name            = var.api_stage_name
  log_group_arn         = module.cloudwatch.api_log_group_arn
  region                = var.region
}

# ─────────────────────────────────────────────
# FRONTEND DEPLOYMENT: AMPLIFY MODULE
# ─────────────────────────────────────────────
module "amplify" {
  source              = "./modules/amplify"
  github_oauth_token  = var.github_oauth_token
  repository_url      = "https://github.com/RareSonal/StockWishlist"
  api_url             = module.api_gateway.api_url
  cognito_user_pool_id = module.cognito.user_pool_id
  cognito_client_id   = module.cognito.client_id
  region              = var.region

  depends_on = [
    module.api_gateway,
    module.cors_root,
    module.cors_v1_proxy,
    module.cors_login,
    module.cors_stocks,
    module.cors_wishlist,
  ]
}
