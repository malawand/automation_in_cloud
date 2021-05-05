# Data block requests that Terraform read from a given datasource, aws_vpc
# and export the result under the given local name, "default"
# Default is used to refer to the resource from elsewhere in the same TF module, 
# but does not have significance outside the module
data "aws_vpc" "default"{
    default = true
}

# Retrieve the default VPC ID fetched above
data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}

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
    default = "TODO"
}



variable "environment" {
    default = "lecture"
}