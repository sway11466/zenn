# --------------------------------
#  public network
# --------------------------------
#  https://zenn.dev/sway/articles/terraform_codebase_mattermost

# --------------------------------
#  subnet
resource "aws_subnet" "public_1a" {
  vpc_id            = aws_vpc.mattermost.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = local.network.public.cider_subnet_1a
  tags = {
    Name        = "${local.env}-subnet-public-1a"
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

resource "aws_subnet" "public_1c" {
  vpc_id            = aws_vpc.mattermost.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = local.network.public.cider_subnet_1c
  tags = {
    Name        = "${local.env}-subnet-public-1c"
    Environment = local.env
    CreatedBy   = "Terraform"
    CreatedOn   = timestamp()
  }
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }
  map_public_ip_on_launch = true # Todo temporary
}

resource "aws_subnet" "public_1d" {
  vpc_id            = aws_vpc.mattermost.id
  availability_zone = "ap-northeast-1d"
  cidr_block        = local.network.public.cider_subnet_1d
  tags = {
    Name        = "${local.env}-subnet-public-1d"
    Environment = local.env
    CreatedBy   = "Terraform"
    CreatedOn   = timestamp()
  }
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }
  map_public_ip_on_launch = true # Todo temporary
}

# --------------------------------
#  internet gateway
resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.mattermost.id
  tags = {
    Name        = "${local.env}-igw"
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
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mattermost.id
  tags = {
    Name        = "${local.env}-route-public"
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

resource "aws_route" "internet_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.public.id
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1d" {
  subnet_id      = aws_subnet.public_1d.id
  route_table_id = aws_route_table.public.id
}

# --------------------------------
#  nat gateway
resource "aws_nat_gateway" "public_1a" {
  allocation_id = aws_eip.public_1a.id
  subnet_id     = aws_subnet.public_1a.id
  tags = {
    Name        = "${local.env}-natgw-public-1a"
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

resource "aws_eip" "public_1a" {
  vpc = true
  tags = {
    Name        = "${local.env}-natgw-eip-public-1a"
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

resource "aws_nat_gateway" "public_1c" {
  allocation_id = aws_eip.public_1c.id
  subnet_id     = aws_subnet.public_1c.id
  tags = {
    Name        = "${local.env}-natgw-public-1c"
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

resource "aws_eip" "public_1c" {
  vpc = true
  tags = {
    Name        = "${local.env}-natgw-eip-public-1c"
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

resource "aws_nat_gateway" "public_1d" {
  allocation_id = aws_eip.public_1d.id
  subnet_id     = aws_subnet.public_1d.id
  tags = {
    Name        = "${local.env}-natgw-public-1d"
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

resource "aws_eip" "public_1d" {
  vpc = true
  tags = {
    Name        = "${local.env}-natgw-eip-public-1d"
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
