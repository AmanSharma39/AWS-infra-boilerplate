variable "env_name" {}
variable "private_subnet_ids" {
    type = list(string)
}
variable "db_name" {
    default = "appdb"
}
variable "db_username" {}
variable "db_password" {}
variable "db_sg_id" {}