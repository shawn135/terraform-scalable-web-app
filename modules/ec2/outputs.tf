# modules/ec2/outputs.tf

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}


# Output the security group ID
output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "elb_sg_id" {
  value = aws_security_group.elb_sg.id
}

output "asg_sg_id" {
  value = aws_security_group.asg_sg.id
}
