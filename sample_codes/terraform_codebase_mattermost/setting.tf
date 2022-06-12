# --------------------------------
#  setting
# --------------------------------
#  https://zenn.dev/sway/articles/terraform_codebase_mattermost

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
    zone_id = "Z099999999GHIJKLMNOPQ"
  }
  aurora = {
    engine    = "aurora-mysql"
    version   = "5.7"
    parameter = "5.7.mysql_aurora.2.10.2"
    instance  = "db.t3.small"
    username  = "admin"
    password  = "password"
  }
  mattermost = {
    ami           = "ami-02c3627b04781eada" // Amazon Linux 2 Kernel 5.10 AMI 2.0.20220426.0 x86_64 HVM gp2
    instance_type = "t3.micro"
    domain_name   = "mattermost.change-domain.com"
  }
}
