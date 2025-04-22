# Get caller identity
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ami" "default" {
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
  most_recent = true
}
