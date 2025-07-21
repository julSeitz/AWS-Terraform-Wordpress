resource "aws_s3_bucket" "scheduled_downtime_static_message_bucket" {

}

resource "aws_s3_bucket_website_configuration" "scheduled_downtime_static_message" {
  bucket = aws_s3_bucket.scheduled_downtime_static_message_bucket.id
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "scheduled_downtime_static_message_public_access" {
  bucket                  = aws_s3_bucket.scheduled_downtime_static_message_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "scheduled_downtime_static_message_object" {
  bucket       = aws_s3_bucket.scheduled_downtime_static_message_bucket.id
  key          = "index.html"
  source       = "Static-Message-Website/index.html"
  etag         = filemd5("Static-Message-Website/index.html")
  content_type = "text/html"
}
