# --------------------------------
#  mattermost
# --------------------------------
#  https://zenn.dev/sway/articles/terraform_codebase_mattermost

# --------------------------------
#  EC2 (Launch Template)
resource "aws_autoscaling_group" "mattermost" {
  name             = "${local.env}-mattermost"
  desired_capacity = 1
  max_size         = 1
  min_size         = 1
  vpc_zone_identifier = [
    aws_subnet.private_1d.id,
    aws_subnet.private_1c.id,
    aws_subnet.private_1d.id
  ]
  launch_template {
    id      = aws_launch_template.mattermost.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.mattermost.arn]
}

resource "aws_launch_template" "mattermost" {
  name          = "${local.env}-mattermost"
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
  user_data              = base64encode(data.template_file.mattermost.rendered)
  update_default_version = true
  lifecycle {
    ignore_changes = [
      tag_specifications["tags"]
    ]
  }
  depends_on = [aws_rds_cluster_instance.mattermost_db]
}

data "template_file" "mattermost" {
  template = file("./mattermost_ec2_userdata.sh")
  vars = {
    AURORA_USER     = local.aurora.username
    AURORA_PASSWORD = local.aurora.password
    AURORA_HOST     = aws_rds_cluster.mattermost_db.endpoint
    S3_BUCKET_NAME  = aws_s3_bucket.mattermost.id
  }
}

# --------------------------------
#  security group
#    add aurora security group ingress
resource "aws_security_group" "mattermost_ec2" {
  name   = "${local.env}-mattermost-ec2"
  vpc_id = aws_vpc.mattermost.id
  ingress {
    from_port       = 8065
    to_port         = 8065
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

resource "aws_security_group_rule" "mattermost_ec2_to_aurora" {
  security_group_id        = aws_security_group.mattermost_db.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.mattermost_ec2.id
}

# --------------------------------
#  iam
resource "aws_iam_instance_profile" "mattermost_ec2" {
  name = "${local.env}-mattermost-ec2"
  role = aws_iam_role.mattermost_ec2.name
}

resource "aws_iam_role" "mattermost_ec2" {
  name               = "${local.env}-mattermost-ec2"
  assume_role_policy = data.aws_iam_policy_document.mattermost_ec2_assume.json
}

data "aws_iam_policy_document" "mattermost_ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "mattermost_ec2_attatch_policy" {
  role       = aws_iam_role.mattermost_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "mattermost_ec2" {
  name   = "${local.env}-mattermost-ec2"
  policy = data.aws_iam_policy_document.mattermost_ec2_policy.json
}

data "aws_iam_policy_document" "mattermost_ec2_policy" {
  statement {
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.mattermost.arn]
  }
}

resource "aws_iam_role_policy_attachment" "mattermost_ec2_attach_ssmrole" {
  role       = aws_iam_role.mattermost_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
