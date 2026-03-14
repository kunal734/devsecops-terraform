variable vpc_cidr{
    description = "CIDR block for the VPC"
    type        = string
}

variable vpc_name {

    description = "Name tag for the VPC"
    type        = string
}

variable public_subnet_cidr {
    description = "CIDR block for the public subnet"
    type        = string
}

variable "availability_zone" {
  description = "Availability zone for the public subnet (must support your instance type, e.g. us-east-1a for t3.micro)"
  type        = string
  default     = "us-east-1a"
}