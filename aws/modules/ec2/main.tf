#-----modules/ec2/main.tf-----

# Setting up Default IAM Role for Instance Profile
# resource "aws_iam_role" "default" {
#   count = local.create_iam ? 1 : 0
#   name                  = "role-${var.server_name}-ec2"
#   assume_role_policy    = data.aws_iam_policy_document.base_role_doc.json
#   path                  = "/"
#   force_detach_policies = true
# }

# data "aws_iam_policy_document" "base_role_doc" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     effect  = "Allow"
#     principals {
#       identifiers = ["ec2.amazonaws.com"]
#       type        = "Service"
#     }
#   }
# }

# # Generating Instance Profile from IAM Role

# resource "aws_iam_instance_profile" "default_profile" {
#   count = local.create_iam ? 1 : 0
#   name       = "role-${module.this.id}-ec2"
#   path       = "/"
#   role       = aws_iam_role.default[0].name
# }

# # Attaching Default SSM Policy to IAM Profile

# resource "aws_iam_role_policy_attachment" "ssm" {
#   count = local.create_iam ? 1 : 0
#   role       = aws_iam_role.default[0].id
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
# }

# # Attaching Default CloudWatch Policy

# resource "aws_iam_role_policy_attachment" "cloudwatch" {
#   count = local.create_iam ? 1 : 0
#   role       = aws_iam_role.default[0].id
#   policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
# }

# # Attaching EC2 Read Only
# resource "aws_iam_role_policy_attachment" "ec2_readonly" {
#   count = local.create_iam ? 1 : 0
#   role       = aws_iam_role.default[0].id
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
# }

# # Attaching Custom Policies (If Defined)
# resource "aws_iam_role_policy_attachment" "custom" {
#   count      = local.create_iam ? length(var.custom_policies) : 0
#   role       = aws_iam_role.default[0].id
#   policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.custom_policies[count.index]}"
# }

module "iam" {
  count               = var.create_iam ? 1 : 0
  source              = "../ec2_iam"
  custom_iam_policies = var.custom_iam_policies

  context = var.context
}

resource "aws_security_group" "default" {
  count = var.create_sg ? 1 : 0
  name  = "${module.this.id}-sg"
  #  description = var.description
  vpc_id = var.vpc_id
  tags = merge(tomap({
    "Name" = "${module.this.id}-sg"
    }),
    module.this.tags,
  )
}

# Sets the default egress rule for the group

resource "aws_security_group_rule" "egress_default" {
  count             = var.create_sg ? var.allow_all_outbound == true ? 1 : 0 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All egress traffic"
  security_group_id = aws_security_group.default[0].id
}

resource "aws_security_group_rule" "rules" {
  count                    = var.create_sg ? length(var.security_group_rules) : 0
  type                     = "ingress"
  description              = var.security_group_rules[count.index].description
  from_port                = var.security_group_rules[count.index].from_port
  to_port                  = var.security_group_rules[count.index].to_port
  protocol                 = var.security_group_rules[count.index].protocol
  cidr_blocks              = var.security_group_rules[count.index].cidr_blocks
  source_security_group_id = var.security_group_rules[count.index].source_security_group_id
  security_group_id        = aws_security_group.default[0].id
  self                     = var.security_group_rules[count.index].self
}

resource "random_password" "admin_pass" {
  #count = var.admin_pass == null ? 1 : 0
  length           = 25
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_integer" "subnet" {
  count = var.subnet_id != null ? 0 : 1
  min   = 0
  max   = tonumber(length(var.private_subnets) - 1)

}

locals {
  subnet = var.subnet_id != null ? var.subnet_id : var.static_subnet_index != null ? var.private_subnets[var.static_subnet_index] : var.private_subnets[random_integer.subnet[0].result]
}

resource "aws_instance" "default" {
  instance_type               = var.instance_type
  ami                         = var.ami_id
  iam_instance_profile        = var.instance_profile != null ? var.instance_profile : var.create_iam ? module.iam[0].instance_profile_id : null
  ebs_optimized               = var.ebs_optimized
  disable_api_termination     = var.termination_protection
  source_dest_check           = var.source_dest_check
  associate_public_ip_address = var.associate_public_ip_address

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.termination_protection ? false : true
    kms_key_id            = var.root_encrypted == true ? var.ebs_key_name : null
    encrypted             = var.root_encrypted
    # tags = merge(tomap({
    #   "Name"     = "${var.server_name}-root"
    #   }),
    #   module.this.tags,
    # )
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  volume_tags = merge(tomap({
    "Name" = "${module.this.id}-root"
    }),
    module.this.tags,
  )

  key_name = var.allow_ssh ? var.ssh_key_name : null
  vpc_security_group_ids = compact(concat([
    var.create_sg ? aws_security_group.default[0].id : null,
    ],
    var.additional_security_groups
    )
  )
  #subnet_id = var.private_subnets[0]
  # subnet_id = element(var.private_subnets, random_integer.subnet.result)
  subnet_id = local.subnet
  # private_ip              = try(var.private_ip[count.index], null)

  user_data = var.user_data != null ? var.user_data : <<EOF
  EOF

  lifecycle {
    ignore_changes = [
      user_data,
      ami,
      volume_tags,
    ]
  }

  tags = merge(tomap({
    "Name" = "${module.this.id}"
    }),
    module.this.tags,
  )

}

resource "aws_ebs_volume" "ebs_volume" {
  for_each          = { for disk in var.disk_map : disk.name => disk }
  availability_zone = aws_instance.default.availability_zone
  encrypted         = each.value.is_encrypted
  kms_key_id        = each.value.is_encrypted ? (each.value.kms_key_arn != null ? each.value.kms_key_arn : var.ebs_key_name) : null
  final_snapshot    = var.termination_protection
  type              = each.value.disk_type
  size              = each.value.disk_size
  iops              = each.value.iops
  throughput        = each.value.throughput

  tags = merge(tomap({
    "Name"     = "${module.this.id}-${each.value.name}",
    "Function" = "Storage",
    }),
    var.tags,
  )
  lifecycle {
    ignore_changes = [
    ]
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  for_each    = { for disk in var.disk_map : disk.name => disk }
  device_name = each.value.device_name
  volume_id   = aws_ebs_volume.ebs_volume[each.key].id
  instance_id = aws_instance.default.id
}
