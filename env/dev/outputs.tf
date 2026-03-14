output "ec2_public_ip" {
  description = "Public IP address of the dev EC2 instance"
  value       = module.ec2.public_ip
}

output "ec2_instance_id" {
  description = "ID of the dev EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_instance_arn" {
  description = "ARN of the dev EC2 instance"
  value       = module.ec2.instance_arn
}