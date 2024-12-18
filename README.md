# Terraform Scalable Web Application

This repository demonstrates how to deploy a scalable web application using **Terraform** on **AWS**. The infrastructure includes:
- A **VPC** with public and private subnets.
- An **Auto Scaling Group (ASG)** to handle dynamic scaling of EC2 instances.
- An **Application Load Balancer (ALB)** to distribute traffic.
- Security groups to manage access control.

---

## **Features**
1. **Infrastructure as Code (IaC)**:
   - Fully automated deployment using Terraform.
   - Modular design for EC2 and VPC components.
   
2. **High Availability**:
   - EC2 instances distributed across multiple availability zones.
   - Auto-scaling based on demand.

3. **Load Balancing**:
   - Application Load Balancer ensures traffic distribution.
   - Target group with health checks to maintain reliability.

4. **Dynamic Scaling**:
   - Supports manual or automatic scaling based on CPU or other metrics.

---

## **Setup and Deployment**

### **Prerequisites**
- Terraform installed ([Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)).
- AWS account with appropriate IAM permissions.
- SSH key pair for accessing EC2 instances.

---

### **Steps**
1. Clone the repository:
   ```bash
   git clone https://github.com/shawn135/terraform-scalable-web-app.git
   cd terraform-scalable-web-app
