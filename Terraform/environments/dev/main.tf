provider "aws" {
  region = "eu-west-1"
}

# module "secrets" {
#   source      = "../../modules/secrets"
#   env_name    = "dev"
#   name        = "db-credentials"
#   description = "Postgres DB credentials for dev"
#   secret_data = {
#     username = "admin"
#     password = var.db_password
#   }
# }

# data "aws_secretsmanager_secret_version" "db" {
#   secret_id = module.secrets.secret_name
# }

module "network" {
  source          = "../../modules/network"
  env_name        = "dev"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs             = ["eu-west-1a", "eu-west-1b"]
}

module "compute" {
  source              = "../../modules/compute"
  env_name            = "dev"
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.private_subnet_ids
  alb_sg_id           = module.network.web_sg_id
  ecs_sg_id           = module.network.web_sg_id
  container_image     = "nginx:latest"
  aws_region = "eu-west-1"
}


module "storage" {
  source        = "../../modules/storage"
  env_name      = "dev"
  env_bucket_name   = "app-files"
  force_destroy = true
}
module "database" {
  source              = "../../modules/database"
  env_name            = "dev"
  private_subnet_ids  = module.network.private_subnet_ids
  db_sg_id            = module.network.db_sg_id
  db_username         =  "postgresuser"#jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)["username"]
  db_password         = "SuperSecretPass123" #jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)["password"]
}



module "monitoring" {
  source = "../../modules/monitoring"

  env_name         = "dev"
  ecs_cluster_name = "dev-cluster"
  ecs_service_name = "dev-service"
  aws_region       = "eu-west-1"
}
