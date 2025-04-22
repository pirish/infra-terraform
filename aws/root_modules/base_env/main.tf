#ssh keypair
resource "aws_key_pair" "ec2" {
  key_name   = "${module.this.id}-key"
  public_key = var.ec2_public_key
}
