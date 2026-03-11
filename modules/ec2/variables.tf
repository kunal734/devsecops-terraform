variable "ami" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance in"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group to associate with the instance"
  type        = string
}

variable "instance_profile" {
  description = "The name of the IAM instance profile to associate with the instance"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
}

variable "user_data" {
  description = "The path to the user data script to run on instance launch (contents will be base64-encoded)"
  type        = string
}

variable "name" {
  description = "Name tag for the EC2 instance"
  type        = string
}