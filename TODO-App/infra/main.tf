provider "aws" {
    region = "${var.region}"
}



resource "aws_launch_configuration" "example" {
    image_id                  = "ami-048f6ed62451373d9"
    instance_type           = "t2.micro"
    name_prefix             = "${var.environment}-${var.application}"
    security_groups         = [aws_security_group.instance.id]
    iam_instance_profile    = "${aws_iam_instance_profile.mongo_profile.name}"
    associate_public_ip_address = false
 
    # Back up the most basic database with empty tables and replace it with the mongorestore script.
    # Look into how replication will sync data with the newly spawned
    # Try to manually type it in
    user_data       = <<-EOF
    #!/bin/bash -i
    sudo yum install git -y
    sudo curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
    sudo yum install -y nodejs -y
    sudo git clone https://github.com/kabirbaidhya/react-todo-app.git /opt/todo_app
    sudo npm install --prefix /opt/todo_app/
    sudo npm start --prefix /opt/todo_app/
    EOF
    
    # Required when using a launch configuration with an autoscaling group
    lifecycle {
        create_before_destroy = true
    }

    enable_monitoring           = false

}


output "test" {
    value = data.aws_subnet_ids.default
}
# Create the ASG itself using the aws_autoscaling_group resource
resource "aws_autoscaling_group" "example" {
    launch_configuration    = aws_launch_configuration.example.name
    # vpc_zone_identifier     = ["subnet-053d5ecaf6fd395d8"]
    vpc_zone_identifier     = data.aws_subnet_ids.default.ids
    # vpc_zone_identifier = [ "subnet-189b5c29" ]


    target_group_arns   = [aws_lb_target_group.asg.arn]
    health_check_type   = "ELB"

    min_size                = 2
    max_size                = 2

    tag {
        key                 = "Name"
        value               = "${var.application}-${var.environment}"
        propagate_at_launch = true
    }
    tag{
        key                 = "ASG"
        value               = "${var.application}-${var.environment}"
        propagate_at_launch = true
    }
}

###########################################
#       Load Balancer Configuration
###########################################
# Create the load balancer
resource "aws_lb" "mongo" {
    name                = "${var.environment}-${var.application}"
    load_balancer_type  = "application"
    subnets             = data.aws_subnet_ids.default.ids
    # subnets               = ["subnet-189b5c29"]
    # subnets             = ["subnet-053d5ecaf6fd395d8"]
    # security_groups     = [aws_security_group.alb.id]
}

# Define a listener for the ALB with aws_lb_listener
resource "aws_lb_listener" "tcp" {
    load_balancer_arn   = aws_lb.mongo.arn
    port                = 80
    protocol            = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.asg.arn
    }
}

resource "aws_security_group" "alb" {
    name    = "${var.environment}-${var.application}-alb"

    # Allow inbound HTTP requests
    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all outbound requests
    # egress {
    #     from_port   = 0
    #     to_port     = 0
    #     protocol    = "-1"
    #     cidr_blocks = ["0.0.0.0/0"]
    # }
}

# Create a target group for the ASG using aws_lbtarget_group
resource "aws_lb_target_group" "asg" {
    name        = "${var.environment}-${var.application}"
    port        = var.server_port
    protocol    = "HTTP"
    vpc_id      = data.aws_vpc.default.id

    # We need to reinstall mongodb and have it spin up faster on boot
}

# Route53 Entry
resource "aws_route53_zone" "private" {
  name = "${var.environment}-${var.region}.com"

  vpc {
    vpc_id   = data.aws_vpc.default.id
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "${var.environment}-${var.application}-${var.region}"
  type    = "A"

  alias {
      name                      = "${aws_lb.mongo.dns_name}"
      zone_id                   = "${aws_lb.mongo.zone_id}"
      evaluate_target_health    = false
  }
}