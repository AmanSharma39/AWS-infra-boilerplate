provider "aws" {
  region = "eu-west-1"
}

module "network" {
  source          = "../../modules/network"
  env_name        = "prod"
  vpc_cidr        = "10.1.0.0/16"
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets = ["10.1.3.0/24", "10.1.4.0/24"]
  azs             = ["eu-west-1a", "eu-west-1b"]
}
