# --------------------------------
#  VPC - network
# --------------------------------

resource "aws_vpc" "mattermost" {
  cidr_block = local.network.vpc.cider
  tags = {
    Name        = "${local.env}-mattermost"
    Environment = local.env
    CreatedBy   = "Terraform"
    CreatedOn   = timestamp()
  }
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }
}
