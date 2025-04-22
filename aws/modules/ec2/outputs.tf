#-----modules/ec2/outputs.tf-----

output "id" {
  value       = aws_instance.default.id
  description = "Instance ID of newly created instance"
}

# output "private_ip" {
#   value = aws_instance.default.*.private_ip
#   description = "Private IP address"
# }

output "instances" {
  value       = aws_instance.default
  description = "List of all instances and attributes"
}

output "iam_role_id" {
  value = var.create_iam ? module.iam[0].role_id : null
}

output "iam_role_arn" {
  value = var.create_iam ? module.iam[0].role_arn : null
}

output "iam_instance_profile_id" {
  value = var.create_iam ? module.iam[0].instance_profile_id : null
}

output "security_group_id" {
  value = var.create_sg ? aws_security_group.default[0].id : null
}

# output "environment" {
#   value = aws_instance.default[0].tags.Environment
# }

output "eni_id" {
  value = aws_instance.default.primary_network_interface_id
}
