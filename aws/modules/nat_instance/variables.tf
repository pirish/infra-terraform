variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet" {
  type        = string
  description = "Public subnet to attach the instance"
}
variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnets cidrs"
}

variable "attach_public_ip" {
  type        = bool
  description = "Attach public IP"
  default     = false
}

variable "instance_type" {
  type        = string
  description = "Type of Instance for EC2 (example: t3.micro, m5a.large)"
  default     = "t3.micro"
}

# variable "security_group_rules" {
#   description = "Security group rules for primary sg"
#   type = list(object({
#     description              = string
#     from_port                = string
#     to_port                  = string
#     protocol                 = optional(string, "tcp")
#     cidr_blocks              = optional(list(string))
#     source_security_group_id = optional(string)
#   }))
#   default = []
# }

# variable "external_security_group_rules" {
#   description = "Security group rules for primary sg"
#   type = list(object({
#     description       = string
#     from_port         = string
#     to_port           = string
#     protocol          = optional(string, "tcp")
#     security_group_id = optional(string)
#   }))
#   default = []
# }

variable "ami_id" {
  type        = string
  description = "AMI to use for EC2 instance."
  default     = null
}

variable "server_name" {
  type        = string
  description = "Server name/function"
  default     = null
}

variable "termination_protection" {
  type        = string
  description = "Enable or disable termination protection"
  default     = true
}

variable "root_volume_type" {
  default     = "gp3"
  type        = string
  description = "Storage Type for EC2 root volume."
}

variable "root_volume_size" {
  default     = "15"
  type        = number
  description = "Volume Size for Root in GB. Default is the size of the base AMI."
}

variable "root_encrypted" {
  default     = true
  type        = bool
  description = "Enable root volume encryption"
}

variable "ebs_optimized" {
  type        = bool
  default     = true
  description = "Enable ebs optimization"
}

variable "ebs_key_arn" {
  type        = string
  description = "ebs kms key arn"
}

variable "ssh_key_name" {
  type        = string
  description = "Name of ssh key"
}

variable "custom_policies" {
  default     = []
  type        = list(any)
  description = "Custom policies ARNs to attach to ec2 role"
}

variable "allow_all_outbound" {
  type        = bool
  description = "Enable all outbound connections in security group"
  default     = true
}

# variable "tags" {
#   type        = map(string)
#   description = "Base tags"
#   default     = null
# }

# variable "instance_config" {
#   type = object({
#     app_identifier          = string
#     instance_type           = optional(string, "t3.medium")
#     cluster_prefix          = optional(string, "00")
#     ami_id                  = optional(string)
#     ami_filter              = optional(string)
#     instance_profile        = optional(string)
#     instance_count          = optional(string, "1")
#     custom_iam_policies     = optional(list(string), [])
#     root_volume_size        = optional(string, "60")
#     subnet_override_pattern = optional(list(string))
#     disk_map = optional(list(object({
#       name         = string
#       device_name  = string
#       disk_size    = string
#       disk_type    = string
#       iops         = optional(string)
#       throughput   = optional(string)
#       mount_path   = optional(string)
#       snap_shot_id = optional(string)
#       is_encrypted = optional(bool)
#       kms_key_arn  = optional(string)
#     })), [])
#     security_group_rules = optional(list(object({
#       description              = string
#       from_port                = string
#       to_port                  = string
#       protocol                 = optional(string, "tcp")
#       cidr_blocks              = optional(list(string))
#       source_security_group_id = optional(string)
#       self                     = optional(bool)
#     })), [])
#     external_security_group_rules = optional(list(object({
#       description       = string
#       from_port         = string
#       to_port           = string
#       protocol          = optional(string, "tcp")
#       cidr_blocks       = optional(list(string))
#       security_group_id = string
#     })), [])
#     additional_security_groups = optional(list(string), [])
#     user_data                  = optional(string)
#   })
#   description = "Instance config map"
# }
