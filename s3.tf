resource "aws_s3_bucket" "wordpress_application_data_bucket" {
  bucket = var.wordpress_application_bucket_name
}
