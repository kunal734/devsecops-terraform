variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "ingress_ports" {
  description = "List of ports to allow for ingress traffic"
  type        = list(number)
}

