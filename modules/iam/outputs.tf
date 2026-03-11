output "profile_id" {
  value       = aws_iam_instance_profile.profile.id
  description = "The ID of the IAM instance profile"
}

output "role_id" {
  value       = aws_iam_role.ec2_role.id
  description = "The ID of the IAM role"
}
