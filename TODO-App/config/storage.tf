provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "database" {
    bucket  = "${var.application}-mongodb-${var.region}"
    acl     = "private"
    force_destroy = true

    # Prevent accidental deletion of the s3 bucket
    # lifecycle {
    #     prevent_destroy     = true
    # }

    # Enable versioning so we can see the full revision history of our state files
    versioning {
        enabled     = true        
    }

    # Enable server-side encryption by default
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm   = "AES256"
            }
        }
    }
}


