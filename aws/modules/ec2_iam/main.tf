#-----modules/ec2_iam/main.tf-----

# Setting up Default IAM Role for Instance Profile
resource "aws_iam_role" "default" {
  name                  = "role-${module.this.id}-ec2"
  assume_role_policy    = data.aws_iam_policy_document.base_role_doc.json
  path                  = "/"
  force_detach_policies = true
}

data "aws_iam_policy_document" "base_role_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

# Generating Instance Profile from IAM Role

resource "aws_iam_instance_profile" "default_profile" {
  name = "role-${module.this.id}-ec2"
  path = "/"
  role = aws_iam_role.default.name
}

# Attaching Default SSM Policy to IAM Profile

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.default.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_read_only" {
  role       = aws_iam_role.default.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

# Attaching Default CloudWatch Policy

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.default.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# AmazonS3ReadOnlyAccess
resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.default.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Attaching EC2 Read Only
resource "aws_iam_role_policy_attachment" "ec2_readonly" {
  role       = aws_iam_role.default.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# Attaching Custom Policies (If Defined)
resource "aws_iam_role_policy_attachment" "custom" {
  count      = length(var.custom_iam_policies)
  role       = aws_iam_role.default.id
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.custom_iam_policies[count.index]}"
}
