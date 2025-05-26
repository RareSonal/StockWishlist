variable "db_username" {}
variable "db_password" {}
variable "use_public_subnet_for_rds" {
  type = bool
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "security_group_id" {
  type = string
}
