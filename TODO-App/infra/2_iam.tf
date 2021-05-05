############################# IAM ROLE #############################
resource "aws_iam_instance_profile" "mongo_profile" {
  name = "${var.environment}-${var.application}-${var.region}"
  role = aws_iam_role.mongodb_role.name
}

resource "aws_iam_role_policy" "mongodb-s3" {
  name = "${var.environment}-${var.application}-s3-${var.region}"
  role = aws_iam_role.mongodb_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = ["*"]
      },
    ]
  })
}

resource "aws_iam_role" "mongodb_role" {
  name = "${var.environment}-${var.application}-${var.region}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
############################# END IAM ROLE #############################