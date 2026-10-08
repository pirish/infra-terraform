data "aws_route53_zone" "account_public_zone" {
  name = var.base_domain
}
