data "aws_vpc" "default" {
    default = true
}

data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}

variable "region" {
    default = "us-east-1"
}

variable "application" {
    default = "TODO"
}

variable "environment" {
    default = "lecture"
}

variable "ami" {
    default = "ami-048f6ed62451373d9"
}

variable "instance_type" {
    default = "t3.micro"
}

variable "target_group_server_port" {
    type = number
    default = "3000"
}

variable "outside_listener_port" {
    description = "The port the listener will listen on from requests coming from the internet"
    type = number
    default = 80
}