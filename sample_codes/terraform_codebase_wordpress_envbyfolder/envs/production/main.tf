# --------------------------------
#  Develop Env
# --------------------------------

terraform {
  required_version = "~> 1.1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "network" {
  source   = "../../modules/network"
  env      = local.env
  network  = local.network
}

module "wordpress_app" {
  source   = "../../modules/wordpress/app"
  env      = local.env
  app      = local.wordpress.app
  network  = module.network
  database = module.wordpress_db
}

output "access_url" {
  value = "http://${module.wordpress_app.alb.dns_name}"
}

module "wordpress_db" {
  source   = "../../modules/wordpress/db"
  env      = local.env
  db       = local.wordpress.db
  network  = module.network
}
