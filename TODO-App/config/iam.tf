    # module "iam-role" {
    #   source = "git::https://github.com/clouddrove/terraform-aws-iam-role.git?ref=tags/0.12.3"

    #   name               = "iam-role"
    #   application        = "mongodb"
    #   environment        = "dev"
    #   label_order        = ["environment", "application", "name"]
    #   assume_role_policy = data.aws_iam_policy_document.default.json

    #   policy_enabled = true
    #   policy         = data.aws_iam_policy_document.iam-policy.json
    # }

    # data "aws_iam_policy_document" "default" {
    #   statement {
    #     effect  = "Allow"
    #     actions = ["sts:AssumeRole"]
    #     principals {
    #       type        = "Service"
    #       identifiers = ["ec2.amazonaws.com"]
    #     }
    #   }
    # }

    # data "aws_iam_policy_document" "iam-policy" {
    #   statement {
    #     actions = [
    #       "s3:GetObject"
    #     ]
    #     effect    = "Allow"
    #     resources = [
    #       "arn:aws:s3:::lumifile-mongodb-us-east-1/provisioning/config/mongod.conf"
    #     ]
    #   }
    # }
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:Get*",
#                 "s3:List*"
#             ],
#             "Resource": "arn:aws:s3:::lumifile-mongodb-us-east-1/provisioning/config/mongod.conf"
#         }
#     ]
# }
