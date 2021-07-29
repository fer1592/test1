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
  #ts:skip=AWS.S3Bucket.EncryptionandKeyManagement.High.0405 No sesitive data will be stored in the bucket.
  #ts:skip=AWS.S3Bucket.IAM.High.0370 No sesitive data will be stored in the bucket.
  #ts:skip=AWS.S3Bucket.LM.MEDIUM.0078 No sesitive data will be stored in the bucket.
  bucket = var.bucketName
  acl    = "private"

  tags = {
    App         = "flugel test"
    Environment = "Development"
  }
}

# Create the first text file with the timestamp as the content
resource "aws_s3_bucket_object" "test-1-txt" {
  #ts:skip=AWS.ASBO.DP.MEDIUM.0034
  bucket  = var.bucketName
  key     = "test1.txt"
  content = formatdate("DD-MM-YYYY hh:mm:ss ZZZZZ",timestamp())
  acl     = "public-read"
  depends_on = [aws_s3_bucket.flugel-s3-bucket-test]
}

# Create the second file with the timestamp as the content
resource "aws_s3_bucket_object" "test-2-txt" {
  #ts:skip=AWS.ASBO.DP.MEDIUM.0034
  bucket  = var.bucketName
  key     = "test2.txt"
  content = formatdate("DD-MM-YYYY hh:mm:ss ZZZZZ",timestamp())
  acl     = "public-read"
  depends_on = [aws_s3_bucket.flugel-s3-bucket-test]
}

# Provide the bucket id, and the download urls of both files to validate they are correct with an automated test
output "bucket_id" {
  value = aws_s3_bucket.flugel-s3-bucket-test.id
}

output "test1_url" {
  value = "https://${ var.bucketName }.s3.us-east-2.amazonaws.com/test1.txt"
}

output "test2_url" {
  value = "https://${ var.bucketName }.s3.us-east-2.amazonaws.com/test2.txt"
}