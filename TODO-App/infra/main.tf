provider "aws" {
    region = "${var.region}"
}

output "test" {
    value = data.aws_subnet_ids.default
}