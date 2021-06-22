# Configure the directory
resource "aws_s3_bucket_object" "service-file" {
  bucket = aws_s3_bucket.config.bucket
  key = "config/"
  content_type = "application/x-directory"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "config" {
    bucket = aws_s3_bucket.config.bucket
    key = "config/node-exporter.service"
    source = "${path.module}/services/node-exporter.service"
    etag = "${filemd5("${path.module}/services/node-exporter.service")}"
    server_side_encryption = "AES256"
}