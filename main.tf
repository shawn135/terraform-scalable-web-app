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



resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a" # Use a different AZ
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b" # Use a different AZ
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-b"
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

# Launch Configuration for Auto Scaling
# Launch Configuration for Auto Scaling Group
resource "aws_launch_configuration" "web" {
  name            = "web-launch-config2"
  image_id        = var.ami_id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.terraform_key.key_name
  security_groups = [module.ec2.asg_sg_id] # Reference the exported security group ID
  user_data       = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y nginx
              sudo service nginx start
              echo "Hello, World from EC2!" > /usr/share/nginx/html/index.html
              EOF
  lifecycle {
    create_before_destroy = true
  }
}




# Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  desired_capacity    = 2                             # Initial number of EC2 instances
  max_size            = 5                             # Maximum number of EC2 instances
  min_size            = 1                             # Minimum number of EC2 instances
  vpc_zone_identifier = [module.vpc.public_subnet_id] # Reference the subnet IDs

  launch_configuration      = aws_launch_configuration.web.id
  health_check_type         = "EC2"
  health_check_grace_period = 300
  wait_for_capacity_timeout = "0"

  tag {
    key                 = "Name"
    value               = "WebServerInstance"
    propagate_at_launch = true
  }

  force_delete      = true
  target_group_arns = [aws_lb_target_group.web_target_group.arn]
}

# Create an Application Load Balancer (ALB)
resource "aws_lb" "web_lb" {
  name               = "web-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id] # Directly reference alb_sg here
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
}


# Create a target group for the ALB to register EC2 instances
resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id # Reference to your VPC

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Create a listener for the ALB to forward traffic to the target group
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      status_code  = 200
      content_type = "text/plain"
      message_body = "OK"
    }
  }
}


resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow HTTP traffic to the load balancer"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

