variable "env_name" {}
variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "alb_sg_id" {}
variable "ecs_sg_id" {}
variable "container_image" {}
variable "aws_region" {}