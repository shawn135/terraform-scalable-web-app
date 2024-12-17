# variables.tf

# Variable for Key Pair Name
variable "key_pair_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  default     = "shawn-ec2-ssh-key.pem"
}

# Variable for Subnet ID
variable "subnet_id" {
  description = "The ID of the subnet to launch the instance in"
  type        = string
}