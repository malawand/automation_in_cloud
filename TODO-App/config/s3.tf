provider "aws" { 
    region = "us-east-1"
}

resource "aws_s3_bucket" "config" {
    bucket = "${var.environment}-${var.component}"
    acl = "private"
    force_destroy = true
    
    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}