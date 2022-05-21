# --------------------------------
#  mattermost
# --------------------------------

# --------------------------------
#  EC2 (Launch Template)
resource "aws_autoscaling_group" "bar" {
  desired_capacity = 1
  max_size         = 1
  min_size         = 1
  vpc_zone_identifier = [
    aws_subnet.public_1d.id,
    aws_subnet.public_1c.id,
    aws_subnet.public_1d.id
  ]
  launch_template {
    id      = aws_launch_template.mattermost.id
    version = "$Latest"
  }
}

resource "aws_launch_template" "mattermost" {
  name          = "mattermost"
  image_id      = local.mattermost.ami
  instance_type = local.mattermost.instance_type
  credit_specification {
    cpu_credits = "standard"
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }
  ebs_optimized          = true
  vpc_security_group_ids = [aws_security_group.mattermost_ec2.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.mattermost_ec2.name
  }
  monitoring {
    enabled = false
  }
  instance_initiated_shutdown_behavior = "terminate"
  disable_api_termination              = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${local.env}-mattermost-ec2"
      Environment = local.env
      CreatedBy   = "Terraform"
      CreatedOn   = timestamp()
    }
  }
  user_data =  data.template_file.mattermost.rendered
}

data "template_file" "mattermost" {
  template = file("./mattermost_ec2_userdata.sh")
  vars = {
    env = local.env
  }
}

# --------------------------------
#  security group
resource "aws_security_group" "mattermost_ec2" {
  name   = "mattermost-ec2"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.mattermost_alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${local.env}-mattermost-ec2-sg"
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

# resource "aws_security_group_rule" "mattermost_ec2_to_aurora" {
#   security_group_id        = aws_security_group.mattermost_db.id
#   type                     = "ingress"
#   from_port                = 3306
#   to_port                  = 3306
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.mattermost_ec2.id
# }

# --------------------------------
#  iam
resource "aws_iam_instance_profile" "mattermost_ec2" {
  name = "mattermost_ec2"
  role = aws_iam_role.mattermost_ec2.name
}

resource "aws_iam_role" "mattermost_ec2" {
  name               = "mattermost_ec2"
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
  role       = aws_iam_role.mattermost_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
