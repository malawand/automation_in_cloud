# Route53 Entry
resource "aws_route53_zone" "private" {
  name = "${var.environment}-${var.region}.com"

  vpc {
    vpc_id   = data.aws_vpc.default.id
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "${var.application}"
  type    = "A"

  alias {
      name                      = "${aws_lb.todo.dns_name}"
      zone_id                   = "${aws_lb.todo.zone_id}"
      evaluate_target_health    = false
  }
}