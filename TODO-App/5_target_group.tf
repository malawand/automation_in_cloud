# Create a target group for the ASG using aws_lbtarget_group

resource "aws_lb_target_group" "target_group" {
    name = "${var.environment}-${var.application}"
    port = "${var.target_group_server_port}"
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
}