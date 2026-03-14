variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "ingress_ports" {
  description = "List of ingress ports to allow in the security group"
  type        = list(number)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}