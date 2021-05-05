resource "aws_autoscaling_group" "example" {
    launch_configuration = aws_launch_configuration.example.name
    vpc_zone_identifier = data.aws_subnet_ids.default.ids

    target_group_arns = [aws_lb_target_group.target_group.arn]
    health_check_type = "ELB"

    min_size = 3
    max_size = 3

    tag {
        key = "Name"
        value   = "${var.application}-${var.environment}"
        propagate_at_launch = true
    }

    tag {
        key = "ASG"
        value   = "${var.application}-${var.environment}"
        propagate_at_launch = true
    }
}