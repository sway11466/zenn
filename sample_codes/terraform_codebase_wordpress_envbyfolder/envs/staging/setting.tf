locals {
  env = "staging"
  network = {
    cider_vpc       = "10.1.0.0/16"
    cider_subnet_1a = "10.1.0.0/20"
    cider_subnet_1c = "10.1.16.0/20"
    cider_subnet_1d = "10.1.32.0/20"
  }
  wordpress = {
    app = {
      ami                 = "ami-03d79d440297083e3"
      instance_type       = "t3.micro"
      cider_subnet_1a_ec2 = "10.1.110.0/24"
      cider_subnet_1a_alb = "10.1.111.0/24"
      cider_subnet_1c_alb = "10.1.112.0/24"
      cider_subnet_1d_alb = "10.1.113.0/24"
    }
    db = {
      engine          = "mysql"
      version         = "5.7"
      parameter       = "default.mysql5.7"
      instance        = "db.t2.micro"
      username        = "admin"
      password        = "password"
      cider_subnet_1a = "10.1.100.0/24"
      cider_subnet_1c = "10.1.101.0/24"
      cider_subnet_1d = "10.1.102.0/24"
    }
  }
}
