data "aws_iam_policy_document" "ec2_key_policy" {

  statement {

    sid = "Enable IAM User Permissions"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = ["kms:*"]

    resources = [
      "*",
    ]
  }

  #   statement {

  #     sid = "ASG service-linked role - Use of the customer managed key"

  #     principals {
  #       type        = "AWS"
  #       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
  #     }

  #     actions = [
  #       "kms:Encrypt",
  #       "kms:Decrypt",
  #       "kms:ReEncrypt*",
  #       "kms:GenerateDataKey*",
  #       "kms:DescribeKey"
  #     ]

  #     resources = [
  #       "*",
  #     ]
  #   }

  #   statement {

  #     sid = "ASG service-linked role - Attachment of persistent resources"

  #     principals {
  #       type        = "AWS"
  #       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
  #     }

  #     condition {
  #       test     = "Bool"
  #       variable = "kms:GrantIsForAWSResource"

  #       values = [true]
  #     }

  #     actions = ["kms:CreateGrant"]

  #     resources = [
  #       "*",
  #     ]
  #   }
}

resource "aws_kms_key" "ec2_key" {
  description         = "EC2 ebs KMS encryption key"
  policy              = data.aws_iam_policy_document.ec2_key_policy.json
  enable_key_rotation = true

  tags = module.this.tags
}

resource "aws_kms_alias" "ec2_key_alias" {
  name          = "alias/pwx/ec2"
  target_key_id = aws_kms_key.ec2_key.key_id

}

resource "aws_kms_key" "ssm_key" {
  description         = "SSM service KMS key"
  enable_key_rotation = true

  tags = module.this.tags
}

resource "aws_kms_alias" "ssm_key_alias" {
  name          = "alias/pwx/ssm"
  target_key_id = aws_kms_key.ssm_key.key_id
}

resource "aws_kms_key" "s3_key" {
  description         = "SSM service KMS key"
  enable_key_rotation = true

  tags = module.this.tags
}

resource "aws_kms_alias" "s3_key_alias" {
  name          = "alias/pwx/s3"
  target_key_id = aws_kms_key.s3_key.key_id
}
