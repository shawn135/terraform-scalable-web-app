Scalable Web Application Infrastructure with Terraform

Description
This project uses Terraform to deploy a scalable web application infrastructure on AWS. It includes creating a VPC, subnets, security groups, and an EC2 instance with an SSH key pair for secure access. This setup serves as the foundational architecture for hosting a scalable web application.

Table of Contents
Technologies Used
Architecture
Project Structure
Pre-requisites
Steps to Reproduce
Outputs


1. Technologies Used
Terraform: Infrastructure as Code (IaC) to automate AWS resources
AWS: Cloud provider for infrastructure deployment
EC2
VPC
Subnets (Public and Private)
Security Groups
Key Pair


2. Architecture
The deployed architecture includes:

VPC: Custom Virtual Private Cloud to host the resources.
Subnets:
Public Subnet: To host resources accessible from the internet.
Private Subnet: For internal resources (optional for future use).
Internet Gateway: To enable internet access for resources in the public subnet.
Security Group: To allow SSH and HTTP traffic to the EC2 instance.
EC2 Instance: A virtual server running in AWS.
Key Pair: SSH key pair for secure access to the EC2 instance.


3. Project Structure
graphql
Copy code
scalable-web-app/
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
├── main.tf            # Root Terraform configuration file
├── variables.tf       # Variables used across the root module
├── outputs.tf         # Outputs from the Terraform resources
├── provider.tf        # AWS Provider configuration
├── terraform.pub      # Public SSH key file
├── README.md          # Project documentation (this file)


4. Pre-requisites
Terraform must be installed. Install Terraform
An AWS account with programmatic access enabled.
AWS CLI configured with valid credentials:

aws configure
SSH Key Pair: Generate a key pair to access the EC2 instance.

ssh-keygen -t rsa -b 4096 -C "terraform@example.com"
Save the public key as terraform.pub.


5. Steps to Reproduce
Step 1: Clone the Repository


git clone https://github.com/your-username/scalable-web-app.git 
cd scalable-web-app

Step 2: Initialize Terraform
Run terraform init to initialize the project and download required providers.

terraform init
Step 3: Review and Update Variables
Edit the variables.tf file or use Terraform CLI input variables to customize the deployment:


variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}
Step 4: Deploy the Infrastructure
Run terraform plan to preview the changes, then apply them:

terraform plan
terraform apply
Type yes when prompted.

Step 5: Access the Deployed EC2 Instance
Once the resources are provisioned, retrieve the public IP of the EC2 instance:
terraform output public_ip

Connect via SSH using the private key:
ssh -i "path/to/your-private-key.pem" ec2-user@<public_ip>

6. Outputs
Once the Terraform configuration is applied, you will see outputs similar to:
Outputs:

instance_id = "i-00f2ca9a477bcce97"
public_ip = "54.83.75.18"

These outputs provide:

Instance ID: The unique identifier of the created EC2 instance.
Public IP: Use this to SSH into the instance or test your deployed application.


Next Steps
Install a web server (like Nginx or Apache) on the EC2 instance.
Configure a Load Balancer to distribute traffic.
Implement Auto Scaling for high availability.
