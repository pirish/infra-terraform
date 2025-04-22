#-----modules/ec2_iam/outputs.tf-----

output "role_id" {
  value = aws_iam_role.default.id
}

output "instance_profile_id" {
  value = aws_iam_instance_profile.default_profile.id
}

output "role_arn" {
  value = aws_iam_role.default.arn
}
