variable "rest_api_id" {
  type = string
}

variable "resource_id" {
  type = string
}

variable "create_options_method" {
  description = "Whether to create the OPTIONS method for CORS"
  type        = bool
  default     = true
}
