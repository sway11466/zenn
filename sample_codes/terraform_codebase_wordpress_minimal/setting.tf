# --------------------------------
#  setting
# --------------------------------

locals {
  env = "codebase"
  network = {
    cider_vpc       = "10.0.0.0/16"
    cider_subnet_1a = "10.0.0.0/20"
    cider_subnet_1c = "10.0.16.0/20"
    cider_subnet_1d = "10.0.32.0/20"
  }
  rds = {
    engine          = "mysql"
    version         = "5.7"
    parameter       = "default.mysql5.7"
    instance        = "db.t2.micro"
    username        = "admin"
    password        = "password"
    cider_subnet_1a = "10.0.100.0/24"
    cider_subnet_1c = "10.0.101.0/24"
    cider_subnet_1d = "10.0.102.0/24"
  }
  application = {
    ami                 = "ami-03d79d440297083e3"
    instance_type       = "t3.micro"
    cider_subnet_1a_ec2 = "10.0.110.0/24"
    cider_subnet_1a_alb = "10.0.111.0/24"
    cider_subnet_1c_alb = "10.0.112.0/24"
    cider_subnet_1d_alb = "10.0.113.0/24"
  }
}
