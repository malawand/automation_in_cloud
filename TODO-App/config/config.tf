resource "aws_s3_bucket_object" "provisioning" {
  bucket  = aws_s3_bucket.database.bucket
  key     = "provisioning/"
  content_type  = "application/x-directory"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "config" {
  bucket = aws_s3_bucket.database.bucket
  key    = "provisioning/config/mongod.conf"
  source = "${path.module}/assets/mongod.conf"
  etag   = "${filemd5("${path.module}/assets/mongod.conf")}"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "backups" {
  bucket  = aws_s3_bucket.database.bucket
  key     = "backups/"
  content_type  = "application/x-directory"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "upload_restore" {
  bucket = aws_s3_bucket.database.bucket
  key    = "provisioning/config/restore.py"
  source = "${path.module}/restore.py"
  etag   = "${filemd5("${path.module}/restore.py")}"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "upload_backup" {
  bucket = aws_s3_bucket.database.bucket
  key    = "provisioning/config/mongoBackup.py"
  source = "${path.module}/mongoBackup.py"
  etag   = "${filemd5("${path.module}/mongoBackup.py")}"
  server_side_encryption = "AES256"
}