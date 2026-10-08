output "instances_summary" {
  description = "Private and Public IPs for each instance."
  value       = module.instance.instances_summary
}

output "instance_id" {
  description = "ocid of created instances. "
  value       = module.instance.instance_id
}

output "private_ip" {
  description = "Private IPs of created instances. "
  value       = module.instance.private_ip
}

output "public_ip" {
  description = "Public IPs of created instances. "
  value       = module.instance.public_ip
}

output "instance_username" {
  description = "Usernames to login to Windows instance. "
  value       = module.instance.instance_username
}

output "instance_password" {
  description = "Passwords to login to Windows instance. "
  sensitive   = true
  value       = module.instance.instance_password
}

output "instance_all_attributes" {
  description = "all attributes of created instance"
  value       = module.instance.instance_all_attributes
}

output "public_ip_all_attributes" {
  description = "all attributes of created public ip"
  value       = module.instance.public_ip_all_attributes
}

output "private_ips_all_attributes" {
  description = "all attributes of created private ips"
  value       = module.instance.private_ips_all_attributes
}

output "vnic_attachment_all_attributes" {
  description = "all attributes of created vnic attachments"
  value       = module.instance.vnic_attachment_all_attributes
}

output "volume_all_attributes" {
  description = "all attributes of created volumes"
  value       = module.instance.volume_all_attributes
}

output "volume_attachment_all_attributes" {
  description = "all attributes of created volumes attachments"
  value       = module.instance.volume_attachment_all_attributes
}
