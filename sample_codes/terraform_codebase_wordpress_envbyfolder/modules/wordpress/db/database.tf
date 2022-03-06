# --------------------------------
#  database
# --------------------------------

# --------------------------------
#  input prameter
variable env {
  type = string
}
variable db {
  type = object({
    engine          = string
    version         = string
    parameter       = string
    instance        = string
    username        = string
    password        = string
    cider_subnet_1a = string
    cider_subnet_1c = string
    cider_subnet_1d = string
  })
}
variable network {
  type = object({
    vpc = object({
      id = string
    })
  })
}

# --------------------------------
#  rds instance
#   - 停止中に差分が出ないようにstatusの変更を無視する
resource "aws_db_instance" "wordpress" {
  identifier             = "${var.env}-wordpress"
  engine                 = var.db.engine
  engine_version         = var.db.version
  instance_class         = var.db.instance
  allocated_storage      = 20
  username               = var.db.username
  password               = var.db.password
  db_name                = "wordpressdb"
  parameter_group_name   = var.db.parameter
  db_subnet_group_name   = aws_db_subnet_group.wordpress_db.name
  vpc_security_group_ids = [aws_security_group.wordpress_db.id]
  skip_final_snapshot    = true
  tags = {
    Name        = "${var.env}-wordpress"
    Environment = var.env
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
  name = "${var.env}-wordpress-db"
  subnet_ids = [
    aws_subnet.wordpress_db_1a.id,
    aws_subnet.wordpress_db_1c.id,
    aws_subnet.wordpress_db_1d.id
  ]
}

resource "aws_subnet" "wordpress_db_1a" {
  vpc_id            = var.network.vpc.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = var.db.cider_subnet_1a
  tags = {
    Name        = "${var.env}-wordpress-db-1a"
    Environment = var.env
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
  vpc_id            = var.network.vpc.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = var.db.cider_subnet_1c
  tags = {
    Name        = "${var.env}-wordpress-db-1c"
    Environment = var.env
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
  vpc_id            = var.network.vpc.id
  availability_zone = "ap-northeast-1d"
  cidr_block        = var.db.cider_subnet_1d
  tags = {
    Name        = "${var.env}-wordpress-db-1d"
    Environment = var.env
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
  vpc_id        = var.network.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.env}-wordpress-db"
    Environment = var.env
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

# --------------------------------
#  output
output "security_group" {
  value = aws_security_group.wordpress_db
}
