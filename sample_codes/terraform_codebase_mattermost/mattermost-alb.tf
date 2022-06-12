# --------------------------------
#  ALB for mattermost
# --------------------------------
#  https://zenn.dev/sway/articles/terraform_codebase_mattermost

# --------------------------------
#  R53
resource "aws_route53_record" "mattermost" {
  zone_id = local.network.zone_id
  name    = local.mattermost.domain_name
  type    = "A"
  alias {
    name                   = aws_lb.mattermost.dns_name
    zone_id                = aws_lb.mattermost.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cert_validation" {
  zone_id = local.network.zone_id
  for_each = {
    for dvo in aws_acm_certificate.mattermost.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  type            = each.value.type
  name            = each.value.name
  records         = [each.value.record]
  ttl             = "300"
  allow_overwrite = true
}

# --------------------------------
#  ssl
resource "aws_acm_certificate" "mattermost" {
  domain_name               = local.mattermost.domain_name
  subject_alternative_names = [local.mattermost.domain_name]
  validation_method         = "DNS"
  tags = {
    Name        = "${local.env}-mattermost-ssl"
    Environment = local.env
    CreatedBy   = "Terraform"
    CreatedOn   = timestamp()
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }
}

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
  tags = {
    Name        = "${local.env}-mattermost-alb"
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
resource "aws_alb_listener" "mattermost" {
  load_balancer_arn = aws_lb.mattermost.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.mattermost.arn
  default_action {
    target_group_arn = aws_lb_target_group.mattermost.arn
    type             = "forward"
  }
  tags = {
    Name        = "${local.env}-mattermost-alb-listener"
    Environment = local.env
    CreatedBy   = "Terraform"
    CreatedOn   = timestamp()
  }
  lifecycle {
    ignore_changes = [
      tags["CreatedOn"]
    ]
  }
  depends_on = [aws_route53_record.cert_validation]
}

# --------------------------------
#  target group
resource "aws_lb_target_group" "mattermost" {
  vpc_id               = aws_vpc.mattermost.id
  name                 = "${local.env}-mattermost"
  port                 = 8065
  protocol             = "HTTP"
  deregistration_delay = "10"
  health_check {
    protocol            = "HTTP"
    path                = "/"
    port                = 8065
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = 200
  }
  tags = {
    Name        = "${local.env}-mattermost-alb-tg"
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
resource "aws_security_group" "mattermost_alb" {
  name   = "mattermost-alb"
  vpc_id = aws_vpc.mattermost.id
  ingress {
    from_port   = 443
    to_port     = 443
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
