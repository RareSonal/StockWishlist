# 📈 StockWishlist – Serverless AWS Stock Tracker

StockWishlist is a **full-stack, serverless web application** to help users securely manage a list of their favorite stocks. 
It supports **user login via Cognito**, a **RESTful Flask API**, and a **responsive Vue.js frontend** — all deployed with AWS services using **Infrastructure as Code (IaC)** via Terraform.


# 🔍 Project Overview

- Users can sign up or log in securely via AWS Cognito.
- Authenticated users can view, add, or remove stocks from their wishlist.
- Serverless architecture: No EC2, no manual provisioning.
- CI/CD is fully automated using GitHub Actions.


# 🧭 Architecture Overview


                        
                                          ┌────────────────────┐
                                          │   GitHub Actions   │
                                          └────────┬───────────┘
                                                   │
                             ┌─────────────────────┼─────────────────────┐
                             ▼                                           ▼
              ┌────────────────────────────┐               ┌────────────────────────────┐        ┌───────────────────┐
              │  Terraform Infrastructure  │               │ Serverless Backend (Lambda)│───────→│    Database       │
              │  - RDS (PostgreSQL)        │               │ - Flask Packaging (Docker) │←───────│   Postgres RDS    │
              │  - AWS Lambda (Flask App)  │               │ - Seed DB via Lambda       │        └───────────────────┘                                     
              │  - API Gateway             │               └────────────┬───────────────┘                                     
              │  - SSM Parameters          |                            |  
              │  - Cloudwatch (Logs)       │                            ▼
              └────────────┬───────────────┘               ┌─────────────────────────┐
                           |                               │  Amplify Frontend       │
                           └─────────────────────────────▶│ - Integrated with       │
                                                           │  Cognito Authentication |              
                                                           └─────────────────────────┘
                                                                   
                                                                      
                                                                      
                                                                      
                                                 
# 🧱 Module Descriptions

| Module            | Description                                         |
| ----------------- | --------------------------------------------------- |
| `bootstrap`       | Sets up S3 + DynamoDB for Terraform state           |
| `ssm_parameters`  | Stores DB credentials and GitHub OAuth token in SSM |
| `security_groups` | SGs for Lambda → RDS                                |
| `rds`             | PostgreSQL RDS instance                             |
| `lambda`          | Flask app, seed DB Lambda, user migration Lambda    |
| `cognito`         | User auth with migration support                    |
| `cloudwatch`      | Logging for Lambda and API Gateway                  |
| `api_gateway`     | REST API integrated with Lambda & Cognito           |
| `cors`            | CORS headers for all routes                         |
| `amplify`         | Vue.js frontend CI/CD with GitHub                   |

                                                 
# 🚀 Deployment Pipeline (CI/CD)
1. 🔧 bootstrap-backend.yml

- Creates S3 and DynamoDB if they don’t exist.
- One-time run: Run workflow → Bootstrap Terraform Backend.

2. ⚙️ deploy.yml

Triggered manually:

- Builds and zips Lambda dependencies in Docker
- Deploys infrastructure via Terraform
- Seeds PostgreSQL using a Lambda function
- Builds and uploads frontend to Amplify

# ⚒️ Manual Deployment Steps
1. Bootstrap State Backend

- terraform -chdir=bootstrap init
- terraform -chdir=bootstrap apply
- Or trigger GitHub workflow: Bootstrap Terraform Backend

2. Build & Deploy (Optional CLI)

- docker build -t lambda-builder .
- docker run -v $PWD:/var/task lambda-builder bash
- Or trigger GitHub workflow: Build Backend, Deploy Terraform, Seed DB, Build Frontend

# 🧪 Test APIs
Use Postman or curl with JWT tokens from Cognito to test:

curl -X GET https://<api_url>/v1/stocks \
-H "Authorization: Bearer <JWT>"

# 🛡️ Security

- Secrets are passed via GitHub Actions secrets.
- All infrastructure is codified with least-privilege principles.
- Terraform state is encrypted and locked using DynamoDB.

# ⚙️ Setup Instructions

 🔧 Prerequisites

- AWS Account with admin permissions
- AWS CLI installed and configured
- Terraform v1.5.6+
- Docker installed (for Lambda packaging)
- Node.js (v18) and Python (v3.12)
- GitHub repository secrets configured



# 🖥️ Local Setup (Optional Dev/Test)

Frontend (Amplify)

- cd frontend
- npm install
- npm run serve

Backend (Lambda Flask App)

- cd backend/lambda_package
- pip install -r requirements.txt
- python app.py  # Run locally if needed

# ☁️ Cloud Setup (Terraform)
1. Bootstrap Backend State Storage

- cd bootstrap
- terraform init
- terraform apply -auto-approve
- Or trigger workflow: Bootstrap Terraform Backend in GitHub Actions.

2. Provision Infrastructure & Deploy

- cd terraform
- terraform init
- terraform apply -auto-approve
- Secrets like DB credentials, Cognito info, and subnet IDs are expected to be provided via terraform.tfvars or through GitHub Actions.

# 🔨 Terraform Usage
The terraform directory deploys:

- VPC-connected RDS instance (PostgreSQL)
- Lambda functions: Flask API, Seeder, User Migration
- API Gateway with Cognito authorizer
- CORS setup for all routes
- CloudWatch logs + metrics
- Vue frontend hosted via AWS Amplify

To deploy:

- cd terraform
- terraform init
- terraform plan
- terraform apply

# 🧱 Tech Stack
| Layer          | Tech                       |
| -------------- | -------------------------- |
| Frontend       | Vue.js 3 + Amplify Console |
| Backend        | Flask (in AWS Lambda)      |
| Database       | Amazon RDS (PostgreSQL)    |
| Authentication | AWS Cognito                |
| API Gateway    | AWS API Gateway (REST)     |
| Infra-as-Code  | Terraform                  |
| CI/CD          | GitHub Actions             |
| Secrets Mgmt   | AWS SSM Parameter Store    |
| Monitoring     | AWS CloudWatch             |
| Packaging      | Docker for Lambda layers   |

# 📬 Contributions
Pull requests and suggestions are welcome! If you'd like to add support for automatic PR-based deploy previews, CI testing, or multi-region deployment — open an issue or PR.
