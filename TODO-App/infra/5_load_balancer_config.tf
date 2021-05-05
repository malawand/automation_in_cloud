###########################################
#       Load Balancer Configuration
###########################################
# Create the load balancer
resource "aws_lb" "mongo" {
    name                = "${var.environment}-${var.application}"
    load_balancer_type  = "application"
    # Data sources allow data to be fetched or computed for use elsewhere in Terraform config
    # Use of data sources allows a Terraform configuration to make use of information defined outside of TF
    # Each provider may offer data sources alongside its set of resource types
    subnets             = data.aws_subnet_ids.default.ids
    # security_groups     = [aws_security_group.alb.id]
}

# Load balancer security group. Optional here
resource "aws_security_group" "alb" {
    name    = "${var.environment}-${var.application}-alb"

    # Allow inbound HTTP requests
    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
