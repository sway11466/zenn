# --------------------------------
#  Aurora for Mattermost
# --------------------------------
#  https://zenn.dev/sway/articles/terraform_codebase_mattermost

# --------------------------------
#  cluster & instance
resource "aws_rds_cluster" "mattermost_db" {
  cluster_identifier              = "${local.env}-mattermost"
  engine                          = local.aurora.engine
  engine_version                  = local.aurora.version
  master_username                 = local.aurora.username
  master_password                 = local.aurora.password
  port                            = 3306
  db_subnet_group_name            = aws_db_subnet_group.mattermost_db.name
  vpc_security_group_ids          = [aws_security_group.mattermost_db.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.mattermost_db.name
  skip_final_snapshot             = true
  apply_immediately               = true
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

resource "aws_rds_cluster_instance" "mattermost_db" {
  cluster_identifier      = aws_rds_cluster.mattermost_db.id
  identifier              = "${local.env}-mattermost-writer"
  engine                  = local.aurora.engine
  engine_version          = local.aurora.version
  instance_class          = local.aurora.instance
  db_subnet_group_name    = aws_db_subnet_group.mattermost_db.name
  db_parameter_group_name = aws_db_parameter_group.mattermost_db.name
}

# --------------------------------
#  subnet group
resource "aws_db_subnet_group" "mattermost_db" {
  name = "${local.env}-mattermost-db"
  subnet_ids = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1c.id,
    aws_subnet.private_1d.id
  ]
}

# --------------------------------
#  security group
#   - ingressは接続元のソースに追加するため変更を無視する
resource "aws_security_group" "mattermost_db" {
  name   = "mattermost-db"
  vpc_id = aws_vpc.mattermost.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${local.env}-mattermost-db"
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

# --------------------------------
#  parameter group
resource "aws_rds_cluster_parameter_group" "mattermost_db" {
  name   = "${local.env}-mattermost-db"
  family = "aurora-mysql5.7"
  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_filesystem"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  parameter {
    name  = "collation_connection"
    value = "utf8mb4_general_ci"
  }
  parameter {
    name  = "collation_server"
    value = "utf8mb4_general_ci"
  }
  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }
}

resource "aws_db_parameter_group" "mattermost_db" {
  name   = "${local.env}-mattermost-db"
  family = "aurora-mysql5.7"
}
