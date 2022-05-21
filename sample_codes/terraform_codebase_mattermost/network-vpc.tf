# --------------------------------
#  VPC - network
# --------------------------------

resource "aws_vpc" "main" {
  cidr_block = local.network.vpc.cider
  tags = {
    Name        = "${local.env}-main"
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
