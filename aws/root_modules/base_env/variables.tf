# variable "aws_account_id" {
#   type        = string
#   description = "AWS Account Number"
# }

variable "vpc_cidr" {
  type        = string
  description = "Cidr range for vpc"
}

variable "ec2_public_key" {
  type        = string
  description = "public key to be used for ec2 access"
}
