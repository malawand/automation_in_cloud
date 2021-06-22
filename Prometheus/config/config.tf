# Configure the directory
resource "aws_s3_bucket_object" "service-file" {
  bucket = aws_s3_bucket.config.bucket
  key = "prometheus/"
  content_type = "application/x-directory"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "service" {
    bucket = aws_s3_bucket.config.bucket
    key = "config/prometheus.service"
    source = "${path.module}/services/prometheus.service"
    etag = "${filemd5("${path.module}/services/prometheus.service")}"
    server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "config" {
    bucket = aws_s3_bucket.config.bucket
    key = "config/prometheus.yml"
    source = "${path.module}/config/prometheus.yml"
    etag = "${filemd5("${path.module}/config/prometheus.yml")}"
    server_side_encryption = "AES256"
}