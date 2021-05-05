# Create the ASG itself using the aws_autoscaling_group resource
resource "aws_autoscaling_group" "example" {
    launch_configuration    = aws_launch_configuration.example.name
    vpc_zone_identifier     = data.aws_subnet_ids.default.ids

    target_group_arns   = [aws_lb_target_group.asg.arn]
    health_check_type   = "ELB"

    min_size                = 1
    max_size                = 1

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