# resource "aws_lb" "todo" {
#     name = "${var.environment}-${var.application}"
#     load_balancer_type = "application"
#     subnets = data.aws_subnet_ids.default.ids
# }

# resource "aws_security_group" "alb" {
#     name = "${var.environment}-${var.application}-alb"

#     ingress {
#         from_port = 3000
#         to_port = 3000
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
# }