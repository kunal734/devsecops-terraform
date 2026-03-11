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

  provisioner "local-exec" {
    command = "echo '${tls_private_key.ec2_key.private_key_pem}' > dev-ec2-key.pem"
  }
}

module "vpc" {
  source              = "../../modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  vpc_name            = "dev-vpc"
}

module "sg" {
  source         = "../../modules/sg"
  vpc_id         = module.vpc.vpc_id
  sg_name        = "dev-sg"
  ingress_ports  = [22, 8080, 9000, 80, 443]
}

module "iam" {
  source = "../../modules/iam"
  name   = "dev-ec2-role"
}

module "ec2" {
  source             = "../../modules/ec2"
  ami                = "ami-0b6c6ebed2801a5cb"
  # t3.micro is currently the Free Tier‑eligible type in most regions
  instance_type      = "t3.micro"
  subnet_id          = module.vpc.public_subnet_id
  security_group_id  = module.sg.sg_id
  instance_profile   = module.iam.profile_id
  key_name           = aws_key_pair.deploykey.key_name
  user_data          = "../../scripts/user_data.sh"
  name               = "dev-devsecops-server"
}