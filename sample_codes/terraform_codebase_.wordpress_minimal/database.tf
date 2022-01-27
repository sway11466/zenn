# --------------------------------
#  database
# --------------------------------

# --------------------------------
#  rds instance
#   - 停止中に差分が出ないようにstatusの変更を無視する
resource "aws_db_instance" "wordpress" {
  identifier           = "${local.env}-wordpress"
  engine               = local.rds.engine
  engine_version       = local.rds.version
  instance_class       = local.rds.instance
  allocated_storage    = 20
  username             = local.rds.username
  password             = local.rds.password
  name                 = "wordpressdb"
  parameter_group_name = local.rds.parameter
  db_subnet_group_name = aws_db_subnet_group.wordpress_db.name
  skip_final_snapshot  = true
  tags = {
    Name        = "${local.env}-wordpress"
    Environment = local.env
    CreatedBy   = "Terraform"
    CreatedOn   = timestamp()
  }
  lifecycle {
    ignore_changes = [
      status,
      tags["CreatedOn"]
    ]
  }
}

# --------------------------------
#  subnet
resource "aws_db_subnet_group" "wordpress_db" {
  name = "${local.env}-wordpress-db"
  subnet_ids = [
    aws_subnet.wordpress_db_1a.id,
    aws_subnet.wordpress_db_1c.id,
    aws_subnet.wordpress_db_1d.id
  ]
}

resource "aws_subnet" "wordpress_db_1a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = local.rds.cider_subnet_1a
  tags = {
    Name        = "${local.env}-wordpress-db-1a"
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

resource "aws_subnet" "wordpress_db_1c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = local.rds.cider_subnet_1c
  tags = {
    Name        = "${local.env}-wordpress-db-1c"
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

resource "aws_subnet" "wordpress_db_1d" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1d"
  cidr_block        = local.rds.cider_subnet_1d
  tags = {
    Name        = "${local.env}-wordpress-db-1d"
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
#  security group
#   - ingressは接続元のソースに追加するため変更を無視する
resource "aws_security_group" "wordpress_db" {
  name   = "wordpress-db"
  vpc_id = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${local.env}-wordpress-db"
    Environment = local.env
    CreatedBy   = "Terraform"
    CreatedOn   = timestamp()
  }
  lifecycle {
    ignore_changes = [
      ingress,
      tags["CreatedOn"]
    ]
  }
}
