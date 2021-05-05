# Create a target group for the ASG using aws_lbtarget_group
resource "aws_lb_target_group" "asg" {
    name        = "${var.environment}-${var.application}"
    port        = var.server_port
    protocol    = "HTTP"
    vpc_id      = data.aws_vpc.default.id

    # We need to reinstall mongodb and have it spin up faster on boot
}
