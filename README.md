# DevSecOps Project

A Terraform-based Infrastructure as Code (IaC) project for deploying a secure DevSecOps environment on AWS with Kubernetes (K3s) integration.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Modules](#modules)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Cleanup](#cleanup)

## 🎯 Overview

This project uses **Terraform** to provision cloud infrastructure on **AWS** with the following components:

- **VPC** - Isolated network environment
- **Security Groups** - Network access control
- **IAM Roles & Policies** - Access management
- **EC2 Instances** - Compute resources with K3s (Kubernetes)
- **SSH Key Pair** - Secure access management

The EC2 instance automatically bootstraps with **K3s** (lightweight Kubernetes) for container orchestration.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS (us-east-1)                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  VPC (10.0.0.0/16)                                     │ │
│  │  ┌──────────────────────────────────────────────────┐  │ │
│  │  │  Public Subnet (10.0.1.0/24)                    │  │ │
│  │  │  ┌────────────────────────────────────────────┐ │  │ │
│  │  │  │  EC2 Instance (t3.micro)                  │ │  │ │
│  │  │  │  - Ubuntu 22.04 LTS                       │ │  │ │
│  │  │  │  - Docker Engine                          │ │  │ │
│  │  │  │  - K3s Kubernetes                         │ │  │ │
│  │  │  │  - IAM Instance Profile (S3 Access)       │ │  │ │
│  │  │  └────────────────────────────────────────────┘ │  │ │
│  │  │  ┌────────────────────────────────────────────┐ │  │ │
│  │  │  │  Security Group                           │ │  │ │
│  │  │  │  - SSH (22)                               │ │  │ │
│  │  │  │  - HTTP (80)                              │ │  │ │
│  │  │  │  - HTTPS (443)                            │ │  │ │
│  │  │  │  - K3s (8080, 9000)                       │ │  │ │
│  │  │  └────────────────────────────────────────────┘ │  │ │
│  │  └──────────────────────────────────────────────────┘  │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## ✅ Prerequisites

### Local Machine Requirements

- [Terraform](https://www.terraform.io/downloads) >= 1.1
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- AWS Account with appropriate permissions
- Git (optional)

### AWS Requirements

- Valid AWS credentials configured locally
- Sufficient permissions to create:
  - VPC, Subnets, Security Groups
  - EC2 instances
  - IAM roles and instance profiles
  - Key pairs

### Configure AWS Credentials

```powershell
aws configure
```

Enter your AWS Access Key ID, Secret Access Key, and default region.

## 📁 Project Structure

```
devsecops-project/
├── README.md                    # This file
├── versions.tf                  # Terraform and provider versions
├── backend/
│   └── backend.tf              # S3 backend configuration (optional)
├── env/
│   └── dev/
│       ├── main.tf             # Main module configuration
│       ├── outputs.tf          # Output values
│       ├── terraform.tfvars    # Environment-specific variables
│       └── variables.tf        # Variable definitions
├── modules/
│   ├── ec2/
│   │   ├── main.tf            # EC2 instance resource
│   │   └── variables.tf        # EC2 module variables
│   ├── iam/
│   │   ├── main.tf            # IAM role and policies
│   │   └── variables.tf        # IAM module variables
│   ├── s3-backend/
│   │   └── backend.tf          # Terraform state backend
│   ├── sg/
│   │   ├── main.tf            # Security group rules
│   │   └── variables.tf        # Security group variables
│   └── vpc/
│       ├── main.tf            # VPC and subnet configuration
│       ├── outputs.tf         # VPC outputs
│       └── variables.tf        # VPC variables
└── scripts/
    └── user_data.sh           # EC2 instance bootstrap script
```

## 🧩 Modules

### 1. VPC Module (`modules/vpc/`)
Creates a VPC with public subnet for hosting EC2 instances.

**Outputs:**
- `vpc_id` - VPC identifier
- `public_subnet_id` - Public subnet identifier

### 2. Security Group Module (`modules/sg/`)
Manages ingress and egress rules for network access control.

**Features:**
- SSH (port 22) for administration
- HTTP (port 80) for web traffic
- HTTPS (port 443) for encrypted web traffic
- K3s ports (8080, 9000) for Kubernetes API

**Outputs:**
- `sg_id` - Security group identifier

### 3. IAM Module (`modules/iam/`)
Creates IAM role with S3 full access policy for EC2 instances.

**Outputs:**
- `profile_id` - Instance profile ID for EC2 attachment
- `role_id` - IAM role identifier

### 4. EC2 Module (`modules/ec2/`)
Provisions EC2 instance with automatic K3s installation.

**Features:**
- t3.micro instance (Free Tier eligible)
- Ubuntu 22.04 LTS
- Automatic Docker and K3s installation
- SSH key-based access

**Outputs:**
- `instance_id` - EC2 instance ID
- `public_ip` - Public IP address

### 5. S3 Backend Module (`modules/s3-backend/`)
(Optional) Configures S3 bucket for remote Terraform state storage.

## 🚀 Getting Started

### 1. Clone or Download the Project

```powershell
cd c:\Users\kunal\OneDrive\Desktop\devsecops-project
```

### 2. Initialize Terraform

```powershell
cd env\dev
terraform init
```

This downloads required providers and prepares the working directory.

### 3. Review the Plan

```powershell
terraform plan
```

This shows what resources will be created without provisioning them.

### 4. Apply Configuration

```powershell
terraform apply
```

Type `yes` when prompted to create the infrastructure.

**Expected Output:**
- Key pair `dev-ec2-key` created
- VPC and subnet created
- Security group configured
- IAM role and instance profile created
- EC2 instance launched with K3s

## ⚙️ Configuration

### Environment Variables

Edit `env/dev/terraform.tfvars` to customize:

```hcl
# AWS Region
aws_region = "us-east-1"

# Instance configuration
instance_type = "t3.micro"
ami           = "ami-0b6c6ebed2801a5cb"  # Ubuntu 22.04 LTS in us-east-1

# Network configuration
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"

# Tags and naming
environment = "dev"
project     = "devsecops"
```

### Key Pair Management

The project automatically generates an RSA key pair:

- **Key Name:** `dev-ec2-key`
- **Private Key File:** `dev-ec2-key.pem` (created in `env/dev/`)
- **Permissions:** Automatically set to 600

### User Data Script

The EC2 instance runs `scripts/user_data.sh` on startup:

```bash
# Updates system packages
# Installs Docker and utilities
# Installs K3s (lightweight Kubernetes)
# Configures user for Docker access
```

## 📤 Deployment

### Step-by-Step Deployment

```powershell
# 1. Navigate to dev environment
cd env\dev

# 2. Initialize (first time only)
terraform init

# 3. Validate configuration
terraform validate

# 4. Plan deployment
terraform plan -out=tfplan

# 5. Apply the plan
terraform apply tfplan

# 6. Get outputs
terraform output
```

### Accessing Your EC2 Instance

```powershell
# Set key permissions (Windows)
icacls dev-ec2-key.pem /inheritance:r /grant:r "%username%":(f)

# SSH into the instance
ssh -i dev-ec2-key.pem ubuntu@<public-ip>

# Or use AWS Systems Manager Session Manager
aws ssm start-session --target <instance-id>
```

### Verifying K3s Installation

Once connected via SSH:

```bash
# Check K3s status
sudo systemctl status k3s

# View K3s version
k3s --version

# Check running containers
sudo docker ps
```

## 🗑️ Cleanup

### Destroy All Resources

```powershell
cd env\dev
terraform destroy
```

Type `yes` when prompted to confirm deletion.

**Note:** This will delete:
- EC2 instance
- VPC and subnets
- Security groups
- IAM roles
- Key pair

### Partial Cleanup

To remove specific resources:

```powershell
# Remove only EC2 instance
terraform destroy -target=module.ec2

# Remove multiple resources
terraform destroy -target=module.ec2 -target=aws_key_pair.deploykey
```

## 📊 Outputs

After successful `terraform apply`, view outputs:

```powershell
terraform output
```

Common outputs:
- **instance_id** - EC2 instance identifier
- **public_ip** - Public IP for SSH access
- **vpc_id** - VPC identifier
- **security_group_id** - Security group identifier

## 🔒 Security Considerations

1. **SSH Access:** Restrict SSH to your IP:
   ```hcl
   # In modules/sg/main.tf
   cidr_blocks = ["YOUR_IP/32"]  # Instead of "0.0.0.0/0"
   ```

2. **IAM Permissions:** Review and restrict S3 access in [modules/iam/main.tf](modules/iam/main.tf):
   ```hcl
   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
   # Consider using more restrictive policies
   ```

3. **Key Management:** Store `dev-ec2-key.pem` securely:
   - Never commit to version control
   - Add to `.gitignore`: `*.pem`
   - Use AWS Secrets Manager for production

4. **State File:** Consider enabling remote state with S3 backend encryption

## 🐛 Troubleshooting

### Error: "The system cannot find the file specified"
- Check module paths in `env/dev/main.tf`
- Ensure folder names match exactly (case-sensitive on Linux)

### Error: "Instance type is not eligible for Free Tier"
- Change `instance_type` from `t2.micro` to `t3.micro`
- Or upgrade to a paid account

### Error: "Key pair already exists"
- Delete existing key: `aws ec2 delete-key-pair --key-name dev-ec2-key`
- Or set `key_name` to a unique name in `env/dev/main.tf`

### K3s not starting
- SSH into instance and check: `sudo journalctl -u k3s -n 50`
- Verify user_data script executed: `cloud-init status`

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [K3s Official Documentation](https://docs.k3s.io/)
- [AWS VPC Guide](https://docs.aws.amazon.com/vpc/)

## 📝 License

This project is provided as-is for educational and DevSecOps training purposes.

## ✉️ Support

For issues or questions:
1. Check Terraform logs: `TF_LOG=debug terraform apply`
2. Review AWS CloudTrail for API errors
3. Check EC2 instance system logs in AWS Console

---

**Last Updated:** March 11, 2026

