data "aws_ami" "this" {
  most_recent = true
  #owners      = ["137112412989"]
  owners = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}
