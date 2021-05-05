provider "aws" {
    region = "${var.region}"
}

resource "aws_instance" "web" {
  ami           = "ami-048f6ed62451373d9"
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}