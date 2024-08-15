provider "aws" {
  region = "eu-central-1"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}

resource "aws_s3_bucket" "bucket-1" {
  bucket = "my-bucket-123-malek"

  tags = {
    Environment = "terraformChamps"
    owner       = var.owner
  }
}

resource "aws_s3_bucket_acl" "bucket-1" {
  bucket = aws_s3_bucket.bucket-1.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_bucket-1" {
  bucket = aws_s3_bucket.bucket-1.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket-1.id
  key    = "logs/example-log-file.txt"
  content = "This is a log file."
}

resource "aws_s3_bucket_policy" "policy-1" {
  bucket = aws_s3_bucket.bucket-1.id
  policy = data.aws_iam_policy_document.doc.json
}

data "aws_iam_policy_document" "doc" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::my-bucket-123-malek/logs/*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::011528258779:user/terraform-user"]
    }
  }
}

terraform {
  backend "s3" {
    bucket = "my-bucket-123-malek"  
    key    = "erakiterrafromstatefiles"  
    region = "eu-central-1"
  }
}