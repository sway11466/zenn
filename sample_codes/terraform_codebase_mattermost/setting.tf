# --------------------------------
#  setting
# --------------------------------

locals {
  env = "codebase"
  network = {
    vpc = {
      cider = "10.0.0.0/16"
    }
    public = {
      cider_subnet_1a = "10.0.0.0/20"
      cider_subnet_1c = "10.0.16.0/20"
      cider_subnet_1d = "10.0.32.0/20"
    }
    private = {
      cider_subnet_1a = "10.0.100.0/24"
      cider_subnet_1c = "10.0.101.0/24"
      cider_subnet_1d = "10.0.102.0/24"
    }
  }
  aurora = {
    engine    = "aurora-mysql"
    version   = "5.7"
    parameter = "5.7.mysql_aurora.2.09.2"
    instance  = "db.t2.micro"
    username  = "admin"
    password  = "password"
  }
  mattermost = {
    ami           = "ami-03d79d440297083e3"
    instance_type = "t3.micro"
  }
}
