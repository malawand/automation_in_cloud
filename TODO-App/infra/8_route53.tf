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