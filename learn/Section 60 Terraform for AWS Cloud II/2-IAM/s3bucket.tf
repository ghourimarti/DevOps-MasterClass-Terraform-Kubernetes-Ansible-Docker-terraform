#################################################
#  1. AWS S3 Bucket
#################################################
# Create AWS S3 Bucket

resource "aws_s3_bucket" "levelup-s3bucket" {
  bucket = "levelup-bucket-141"
   aws_s3_bucket_acl    = "private"  # acl

  tags = {
    Name = "levelup-bucket-141"
  }
}

