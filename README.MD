# Terraform EC2 with Jenkins, Python, and Docker

This Terraform configuration creates an AWS infrastructure that provisions EC2 instances with Jenkins, Python, and Docker installed. It allows users to run Jenkins directly on the EC2 instance, manage Python-based test automation, and use Docker for containerization.

## Features

- **Provision EC2 Instances**: Create multiple EC2 instances for participants.
- **Jenkins Installation**: Jenkins is installed and runs on port 8080.
- **Python and Docker**: The EC2 instance has Python and Docker pre-installed.
- **Customizable Instance Size**: Easily adjust the size of the instances or EBS volumes.
- **Automated Setup**: The `user_data` script handles the entire setup process.

---

## Prerequisites

- **AWS CLI** installed and configured with appropriate permissions.
- **Terraform** installed. [Download here](https://www.terraform.io/downloads.html).
- **SSH Key Pair**: A valid AWS key pair for accessing the EC2 instances.

---

## Setup Instructions

### 1. Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/dasrodriguezs94/tf-workshop.git
cd your-repo
```

### 2. Configure AWS Credentials
Ensure your AWS credentials are configured either through the AWS CLI (aws configure) or by setting up the proper environment variables:

``` bash
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
```

### 3. Update Terraform Variables
You can customize the configuration by editing the ```variables.tf``` file:

``` hcl
variable "participant_count" {
  description = "Number of workshop participants"
  default     = 2  # Adjust this value based on the number of EC2 instances you need
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "AWS Key Pair name"
  default     = "your-key-name"
}

variable "ami_id" {
  description = "The AMI ID for a Linux distribution (e.g., Ubuntu) with Docker and Python support"
  default     = "ami-0c55b159cbfafe1f0"
}
```

### 4. Provision the Infrastructure
Initialize Terraform and apply the configuration to provision your AWS infrastructure:

``` bash
terraform init
terraform apply
```
During the terraform apply step, you’ll be asked to confirm the changes. Type yes to proceed.

### 5. Access Jenkins
Once Terraform has finished provisioning the infrastructure, you can access Jenkins:

Find the public IPs of the EC2 instances by running:

```bash
terraform output instance_public_ips
```

Open a browser and navigate to:

```http://<public_ip>:8080```

To retrieve the Jenkins initial admin password, SSH into the instance:

``` bash
ssh -i workshop-key.pem ubuntu@<public_ip>
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Paste the password in the Jenkins login screen to complete the setup.

## Infrastructure Details
- VPC and Subnet: A VPC with a public subnet is created to allow EC2 instances to be accessible over the internet.
- Security Groups: Security group rules are set up to allow SSH (port 22) and HTTP traffic (port 8080) for Jenkins.
- EC2 Instances: EC2 instances are created with the following software installed:
    - Jenkins (running on port 8080).
    - Python 3.
    - Docker (with the user ubuntu added to the Docker group for easier management).

## Terraform Configuration Files
- provider.tf: Defines the AWS provider configuration.
- variables.tf: Defines variables such as instance type, AMI ID, and key pair name.
- network.tf: Creates a VPC, subnet, internet gateway, and route table for the infrastructure.
- security_group.tf: Defines security group rules for SSH (port 22) and HTTP (port 8080).
- ec2_instances.tf: Provisions the EC2 instances and installs Jenkins, Python, and Docker using the user_data script.
- outputs.tf: Outputs the public IPs of the created EC2 instances.

## Customization
You can customize the infrastructure by modifying the values in the ```variables.tf``` file:

- Participant Count: Adjust the number of EC2 instances by changing the participant_count variable.
- Instance Size: Change the instance type by modifying the instance_type variable.
- Disk Size: You can increase the disk space by modifying the root_block_device section in ec2_instances.tf.

## Cleanup
To avoid incurring ongoing charges, make sure to destroy the infrastructure when it’s no longer needed:

``` bash
terraform destroy
```
## Troubleshooting
- SSH Issues: If you cannot SSH into the instance, ensure that the correct key pair is being used and that the security group allows SSH access from your IP.

- Jenkins Not Accessible: If Jenkins is not accessible, ensure that port 8080 is open in the security group and that Jenkins is running:

```bash
sudo systemctl status jenkins
```
- Insufficient Disk Space: You can increase the disk size of the EC2 instances by adjusting the root_block_device configuration.
