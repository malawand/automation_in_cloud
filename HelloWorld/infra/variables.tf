variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    default     = 3000
}
variable "http_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    default     = 443
}
variable "metrics_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    default     = 9100
}
variable "ssh_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    default     = 22
}

variable "region" {
    default = "us-east-1"
}

variable "application" {
    default = "mongodb"
}

data "aws_vpc" "default"{
    default = true
}

data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}

variable "environment" {
    default = "lecture"
}



variable "ami_id" {
    default = "ami-048f6ed62451373d9"
}

variable "instance_size" {
    default = "t3.micro"
}