provider "aws" {
  region = "up-south-1"  # Change this to your AWS region
}

variable "bucket_name" {
  default = "trybucketname"
}

resource "aws_s3_object" "example_object" {
  bucket = var.bucket_name
  key    = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
  server_side_encryption = "AES256"
}

output "bucket_url" {
  value = aws_s3_object.example_object.bucket
}
