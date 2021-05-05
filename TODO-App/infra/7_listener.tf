# Define a listener for the ALB with aws_lb_listener
resource "aws_lb_listener" "tcp" {
    load_balancer_arn   = aws_lb.todo.arn
    port                = 80
    protocol            = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.asg.arn
    }
}
