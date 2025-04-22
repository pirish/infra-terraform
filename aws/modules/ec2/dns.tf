# resource "aws_route53_record" "instance" {
#   name    = "${lower(aws_instance.default.tags.Name)}.${var.env_domain}"
#   zone_id = var.private_zone_id
#   type    = "A"
#   ttl     = 300

#   records = [aws_instance.default.private_ip]
# }
