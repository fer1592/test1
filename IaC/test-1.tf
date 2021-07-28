variable "bucketName" {
  type = string
}

# Required Providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

# Create an S3 bucket
resource "aws_s3_bucket" "flugel-s3-bucket-test" {
  bucket = "${ var.bucketName }"
  acl    = "private"

  tags = {
    App         = "flugel test"
    Environment = "Development"
  }
}

resource "aws_s3_bucket_object" "test-1-txt" {
  bucket  = "${ var.bucketName }"
  key     = "test1.txt"
  content = "${ formatdate("DD-MM-YYYY hh:mm:ss ZZZZZ",timestamp()) }"
  acl     = "public-read"
  depends_on = [aws_s3_bucket.flugel-s3-bucket-test]
}

resource "aws_s3_bucket_object" "test-2-txt" {
  bucket  = "${ var.bucketName }"
  key     = "test2.txt"
  content = "${ formatdate("DD-MM-YYYY hh:mm:ss ZZZZZ",timestamp()) }"
  acl     = "public-read"
  depends_on = [aws_s3_bucket.flugel-s3-bucket-test]
}

output "bucket_id" {
  value = aws_s3_bucket.flugel-s3-bucket-test.id
}

output "test1_url" {
  value = "https://${ var.bucketName }.s3.us-east-2.amazonaws.com/test1.txt"
}

output "test2_url" {
  value = "https://${ var.bucketName }.s3.us-east-2.amazonaws.com/test2.txt"
}