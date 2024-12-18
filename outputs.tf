output "instance_id" {
  value = module.ec2.instance_id
}

output "public_ip" {
  value = module.ec2.public_ip
}

output "load_balancer_dns" {
  value       = aws_lb.web_lb.dns_name
  description = "The DNS name of the Application Load Balancer"
}
