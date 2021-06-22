resource "aws_security_group" "instance" {
    name = "${var.environment}-${var.application}"

    ############## Ingress ##############
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ############## Egress ##############
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}