# --------------------------------
#  S3 for mattermost
# --------------------------------

resource "aws_s3_bucket" "mattermost" {
  bucket = "${local.env}-mattermost-data"
  tags = {
    Name        = "${local.env}-mattermost-ec2"
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

resource "aws_s3_bucket_acl" "mattermost" {
  bucket = aws_s3_bucket.mattermost.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "mattermost" {
  bucket                  = aws_s3_bucket.mattermost.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mattermost" {
  bucket = aws_s3_bucket.mattermost.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "mattermost" {
  bucket = aws_s3_bucket.mattermost.id
  rule {
    id     = "archive"
    status = "Enabled"
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
    transition {
      days          = 90
      storage_class = "DEEP_ARCHIVE"
    }
  }
}
