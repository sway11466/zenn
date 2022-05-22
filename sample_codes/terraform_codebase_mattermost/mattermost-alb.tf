# --------------------------------
#  ALB for mattermost
# --------------------------------

# --------------------------------
#  alb
resource "aws_lb" "mattermost" {
  name               = "${local.env}-mattermost"
  load_balancer_type = "application"
  internal           = false
  idle_timeout       = 60
  subnets = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id,
    aws_subnet.public_1d.id
  ]
  security_groups = [aws_security_group.mattermost_alb.id]
  #todo access log
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

output "access_url" {
  value = "http://${aws_lb.mattermost.dns_name}"
}

# --------------------------------
#  listener
resource "aws_alb_listener" "mattermost" {
  load_balancer_arn = aws_lb.mattermost.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.mattermost.arn
    type             = "forward"
  }
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

# --------------------------------
#  target group
resource "aws_lb_target_group" "mattermost" {
  vpc_id               = aws_vpc.main.id
  name                 = "${local.env}-mattermost"
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

# resource "aws_lb_target_group_attachment" "mattermost-targetgroup-attach" {
#   target_group_arn = aws_lb_target_group.mattermost.arn
#   target_id        = aws_instance.mattermost.id
#   port             = 80
# }

# --------------------------------
#  security group
resource "aws_security_group" "mattermost_alb" {
  name   = "mattermost-alb"
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
    Name        = "${local.env}-mattermost-alb-sg"
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
