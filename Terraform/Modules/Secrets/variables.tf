variable "env_name" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "name" {
  description = "db-credentials"
  type        = string
}

variable "description" {
  description = "Secret description"
  type        = string
  default     = ""
}

variable "secret_data" {
  description = "Secret values in JSON"
  type        = map(string)
}