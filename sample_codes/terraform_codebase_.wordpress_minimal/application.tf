# --------------------------------
#  application
# --------------------------------

# --------------------------------
#  alb
resource "aws_lb" "wordpress" {
  name                       = "${local.env}-wordpress"
  load_balancer_type         = "application"
  internal                   = false
  idle_timeout               = 60
  subnets = [
    aws_subnet.application_alb_1a.id,
    aws_subnet.application_alb_1c.id,
    aws_subnet.application_alb_1d.id
  ]
  security_groups = [aws_security_group.wordpress_alb.id]
  #access log
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
    path                = "/"
    port                = 80
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    matcher             = 200
  }
}

resource "aws_lb_target_group_attachment" "myinstance" {
  target_group_arn = aws_lb_target_group.wordpress.arn
  target_id        = aws_instance.wordpress.id
  port             = 80
}

# --------------------------------
#  ec2
resource "aws_instance" "wordpress" {
  ami           = local.application.ami
  instance_type = local.application.instance_type
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "gp3"
    volume_size = 20
  }
  subnet_id                   = aws_subnet.application_ec2.id
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.wordpress_ec2.id]
  #user_data                   = file("./userdata/cloud-init.tpl")
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
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1d"
  cidr_block        = local.application.cider_subnet_1a_ec2
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

# --------------------------------
#  security group
resource "aws_security_group" "wordpress_alb" {
  name        = "wordpress-alb"
  vpc_id      = aws_vpc.main.id
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
  name        = "wordpress-alb"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
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
