terraform {
  backend "s3" {
    bucket         = "raresonal-stockwishlist-terraform-state-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "raresonal-stockwishlist-terraform-lock-table"
    encrypt        = true
  }
}
