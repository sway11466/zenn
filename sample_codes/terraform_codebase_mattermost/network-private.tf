# --------------------------------
#  private network
# --------------------------------
#  https://zenn.dev/sway/articles/terraform_codebase_mattermost

# --------------------------------
#  subnet
resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.mattermost.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = local.network.private.cider_subnet_1a
  tags = {
    Name        = "${local.env}-subnet-private-1a"
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

resource "aws_subnet" "private_1c" {
  vpc_id            = aws_vpc.mattermost.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = local.network.private.cider_subnet_1c
  tags = {
    Name        = "${local.env}-subnet-private-1c"
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

resource "aws_subnet" "private_1d" {
  vpc_id            = aws_vpc.mattermost.id
  availability_zone = "ap-northeast-1d"
  cidr_block        = local.network.private.cider_subnet_1d
  tags = {
    Name        = "${local.env}-subnet-private-1d"
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

# --------------------------------
#  route table
resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.mattermost.id
  tags = {
    Name        = "${local.env}-route-private-1a"
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

resource "aws_route" "private_1a_internet_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_1a.id
  nat_gateway_id         = aws_nat_gateway.public_1a.id
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_1a.id
}

resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.mattermost.id
  tags = {
    Name        = "${local.env}-route-private-1c"
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

resource "aws_route" "private_1c_internet_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_1c.id
  nat_gateway_id         = aws_nat_gateway.public_1c.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private_1c.id
}

resource "aws_route_table" "private_1d" {
  vpc_id = aws_vpc.mattermost.id
  tags = {
    Name        = "${local.env}-route-private-1d"
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

resource "aws_route" "private_1d_internet_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_1d.id
  nat_gateway_id         = aws_nat_gateway.public_1d.id
}

resource "aws_route_table_association" "private_1d" {
  subnet_id      = aws_subnet.private_1d.id
  route_table_id = aws_route_table.private_1d.id
}
