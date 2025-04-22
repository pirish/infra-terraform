#-----modules/ec2/variables.tf-----
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets"
  default     = []
}

# variable "env_domain" {
#   type        = string
#   description = "Account fqdn tail"
# }

variable "private_zone_id" {
  type        = string
  description = "Private hosted zone ID"
  default     = null
}

variable "public_zone_id" {
  type        = string
  description = "Public hosted zone ID"
  default     = null
}

variable "instance_type" {
  type        = string
  description = "Type of Instance for EC2 (example: t3.micro, m5a.large)"
  default     = "t3.micro"
}

variable "security_group_rules" {
  description = "Security group rules for primary sg"
  type = list(object({
    description              = string
    from_port                = string
    to_port                  = string
    protocol                 = optional(string, "tcp")
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
    self                     = optional(bool)
  }))
  default = []
}


variable "additional_security_groups" {
  type        = list(string)
  description = "List of Security Group IDs"
  default     = []
}

variable "ami_id" {
  type        = string
  description = "AMI to use for EC2 instance."
}

# variable "server_name" {
#   type        = string
#   description = "Server name/function"
# }

variable "termination_protection" {
  type        = string
  description = "Enable or disable termination protection"
  default     = true
}

# Optional
variable "create_sg" {
  type        = bool
  description = "Enable creation of security group"
  default     = true
}

variable "create_iam" {
  type        = bool
  description = "Enable creation of iam role"
  default     = true
}

variable "allow_ssh" {
  type        = string
  default     = false
  description = "Allow ssh key authentication"
}

variable "ssh_key_name" {
  type        = string
  default     = null
  description = "ssh key name to overide default naming convention"
}

variable "ebs_key_name" {
  type        = string
  description = "EBS KMS key name to overide default naming convention"
  default     = null
}

variable "instance_profile" {
  default     = null
  type        = string
  description = "IAM Instance Profile Name,Arn,ID to use for EC2. Can use output from IAM module."
}

variable "admin_pass" {
  type        = string
  description = "Password for admin user"
  default     = null
}

variable "user_data" {
  default     = null
  type        = string
  description = "Userdata to include in launch template."
}


variable "root_volume_type" {
  default     = "gp3"
  type        = string
  description = "Storage Type for EC2 root volume."
}

## NOTE: Setting a default value for root_volume_size here is not working, default values are set in:
##  /aws/rootModules/appServer/variables.tf & /aws/rootModules/loadBalancedAppServer/variables.tf
variable "root_volume_size" {
  default     = "30"
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

variable "disk_map" {
  description = "Additional volumes to attach to instance"
  type = list(object({
    name         = string
    device_name  = string
    disk_size    = string
    disk_type    = string
    iops         = optional(string)
    throughput   = optional(string)
    mount_path   = optional(string)
    snap_shot_id = optional(string)
    is_encrypted = optional(bool, true)
    kms_key_arn  = optional(string)
  }))
  default = []
}


variable "playbook" {
  default = "Linux Base Provision"
  type    = string
}

variable "custom_iam_policies" {
  default     = []
  type        = list(any)
  description = "Custom policies ARNs to attach to ec2 role"
}

variable "allow_all_outbound" {
  type        = bool
  description = "Enable all outbound connections in security group"
  default     = true
}

variable "subnet_id" {
  type        = string
  description = "ID of subnet to overide randomization"
  default     = null
}

variable "static_subnet_index" {
  type        = number
  description = "Index of subnet to use"
  default     = null
}

variable "source_dest_check" {
  type        = bool
  description = "Source/ Destination check"
  default     = true
}

variable "associate_public_ip_address" {
  type        = bool
  description = "associate public up"
  default     = false
}
# variable "app_identifier" {
#   type        = string
#   description = "Application identifier"
#   default     = null
# }

# variable "tags" {
#   type        = map(string)
#   description = "Base tags"
#   default     = null
# }
