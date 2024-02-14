resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name

  versioning {
    enabled = true
  }

  
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.example_bucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.example_bucket.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style" {
  bucket       = aws_s3_bucket.example_bucket.id
  key          = "style.css"
  source       = "style.css"
  content_type = "text/css"
}

resource "aws_s3_object" "script" {
  bucket       = aws_s3_bucket.example_bucket.id
  key          = "script.js"
  source       = "script.js"
  content_type = "text/javascript"
}

resource "aws_s3_bucket_policy" "example_bucket_policy" {
  bucket = aws_s3_bucket.example_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  =  ["arn:aws:s3:::${aws_s3_bucket.example_bucket.bucket}/*"]
      }
    ]
  })
}


resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.example_bucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [
    aws_s3_object.index,
    aws_s3_object.error,
    aws_s3_object.style,
    aws_s3_object.script,
  ]
}
