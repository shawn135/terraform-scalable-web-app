# main.tf



# Define VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "scalable-web-app-vpc"
  }
}

# Define Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}



# Define an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "scalable-web-app-internet-gateway"
  }
}



# root main.tf

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}

module "ec2" {
  source        = "./modules/ec2"
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_id
  ami_id        = "ami-0c02fb55956c7d316" # Example AMI ID
  instance_type = "t2.micro"
  key_pair_name = aws_key_pair.terraform_key.key_name
}


resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform"                  # Name of the key pair in AWS
  public_key = file("~/.ssh/terraform.pub") # Path to the public key file
}
