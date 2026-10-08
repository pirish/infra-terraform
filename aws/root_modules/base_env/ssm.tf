module "ssm" {
  source = "bridgecrewio/session-manager/aws"
  ## Module needs a cludge to work with latest provider.  Open PR's with fix, module looks to be abandoned
  ## TODO: Create or Fork replacement.
  version = "v0.4.2"

  bucket_name            = "${module.this.id}-cw-session-logs"
  access_log_bucket_name = "${module.this.id}-cw-access-logs"
  kms_key_alias          = "alias/pwx/ssm"

  tags = module.this.tags

  vpc_id                           = aws_vpc.main.id
  subnet_ids                       = [for sub in aws_subnet.private : sub.id]
  vpc_endpoint_private_dns_enabled = false
  enable_log_to_s3                 = true
  enable_log_to_cloudwatch         = true
  vpc_endpoints_enabled            = true


}
