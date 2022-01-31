# --------------------------------
#  application
# --------------------------------

# --------------------------------
#  alb
resource "aws_lb" "wordpress" {
  name               = "${local.env}-wordpress"
  load_balancer_type = "application"
  internal           = false
  idle_timeout       = 60
  subnets = [
    aws_subnet.application_alb_1a.id,
    aws_subnet.application_alb_1c.id,
    aws_subnet.application_alb_1d.id
  ]
  security_groups = [aws_security_group.wordpress_alb.id]
  #todo access log
  tags = {
    Name        = "${local.env}-wordpress"
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

output "access_url" {
  value = "http://${aws_lb.wordpress.dns_name}"
}

# --------------------------------
#  listener
resource "aws_alb_listener" "wordpress" {
  load_balancer_arn = aws_lb.wordpress.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.wordpress.arn
    type             = "forward"
  }
  tags = {
    Name        = "${local.env}-wordpress"
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
#  target group
resource "aws_lb_target_group" "wordpress" {
  vpc_id               = aws_vpc.main.id
  name                 = "${local.env}-wordpress"
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = "10"
  health_check {
    protocol            = "HTTP"
    path                = "/readme.html"
    port                = 80
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = 200
  }
  tags = {
    Name        = "${local.env}-wordpress"
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

resource "aws_lb_target_group_attachment" "wordpress-targetgroup-attach" {
  target_group_arn = aws_lb_target_group.wordpress.arn
  target_id        = aws_instance.wordpress.id
  port             = 80
}

# --------------------------------
#  ec2
resource "aws_instance" "wordpress" {
  ami           = local.application.ami
  instance_type = local.application.instance_type
  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
    delete_on_termination = true
    tags = {
      Name        = "${local.env}-wordpress"
      Environment = local.env
      CreatedBy   = "Terraform"
    }
  }
  subnet_id                   = aws_subnet.application_ec2.id
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.wordpress_ec2.id]
  iam_instance_profile        = aws_iam_instance_profile.wordpress_ec2.name
  user_data                   = file("./application_ec2_userdata.sh")
  tags = {
    Name        = "${local.env}-wordpress"
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
#  subnet
resource "aws_subnet" "application_ec2" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "ap-northeast-1d"
  cidr_block              = local.application.cider_subnet_1a_ec2
  map_public_ip_on_launch = true
  tags = {
    Name        = "${local.env}-application-ec2"
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

resource "aws_route_table_association" "application_ec2" {
  subnet_id      = aws_subnet.application_ec2.id
  route_table_id = aws_route_table.main.id
}

resource "aws_subnet" "application_alb_1a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = local.application.cider_subnet_1a_alb
  tags = {
    Name        = "${local.env}-application-alb-1a"
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

resource "aws_route_table_association" "application_alb_1a" {
  subnet_id      = aws_subnet.application_alb_1a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_subnet" "application_alb_1c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = local.application.cider_subnet_1c_alb
  tags = {
    Name        = "${local.env}-application-alb-1c"
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

resource "aws_route_table_association" "application_alb_1c" {
  subnet_id      = aws_subnet.application_alb_1c.id
  route_table_id = aws_route_table.main.id
}

resource "aws_subnet" "application_alb_1d" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1d"
  cidr_block        = local.application.cider_subnet_1d_alb
  tags = {
    Name        = "${local.env}-application-alb-1d"
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

resource "aws_route_table_association" "application_alb_1d" {
  subnet_id      = aws_subnet.application_alb_1d.id
  route_table_id = aws_route_table.main.id
}

# --------------------------------
#  security group
resource "aws_security_group" "wordpress_alb" {
  name   = "wordpress-alb"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${local.env}-application-alb-1d"
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

resource "aws_security_group" "wordpress_ec2" {
  name   = "wordpress-ec2"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${local.env}-application-alb-1d"
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

resource "aws_security_group_rule" "wordpress_ec2_to_rds" {
  security_group_id        = aws_security_group.wordpress_db.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.wordpress_ec2.id
}

# --------------------------------
#  iam
resource "aws_iam_instance_profile" "wordpress_ec2" {
  name = "wordpress_ec2"
  role = aws_iam_role.wordpress_ec2.name
}

resource "aws_iam_role" "wordpress_ec2" {
  name               = "wordpress_ec2"
  assume_role_policy = data.aws_iam_policy_document.ssm_role.json
}

data "aws_iam_policy_document" "ssm_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ssm_role" {
  role       = aws_iam_role.wordpress_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
