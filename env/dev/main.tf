provider "aws" {
  region = "us-east-1"
}

# Add the key pair here:
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deploykey" {
  key_name   = "dev-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "${path.module}/dev-ec2-key.pem"
}

module "vpc" {
  source              = "../../modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  vpc_name            = "dev-vpc"
}

module "sg" {
  source         = "../../modules/sg"
  vpc_id         = module.vpc.vpc_id
  sg_name        = "dev-sg"
  ingress_ports  = var.ingress_ports
}

module "iam" {
  source = "../../modules/iam"
  name   = "dev-ec2-role"
}

module "ec2" {
  source             = "../../modules/ec2"
  ami                = "ami-0b6c6ebed2801a5cb"
  instance_type      = var.instance_type
  subnet_id          = module.vpc.public_subnet_id
  security_group_id  = module.sg.sg_id
  instance_profile   = module.iam.profile_id
  key_name           = aws_key_pair.deploykey.key_name
  user_data          = "../../scripts/user_data.sh"
  name               = "dev-devsecops-server"
}