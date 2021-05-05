provider "aws" {
    region = "${var.region}"
}

resource "aws_instance" "web" {
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_size}"

  tags = {
    Name = "HelloWorld"
  }
}