output "alb_target_group_arn" {
  description = "ARN of the Application Load Balancer target group"
  value       = aws_lb_target_group.app_http.arn
}

output "bastion_host_public_ip" {
  description = "Public IP address of the Bastion host"
  value       = aws_instance.bastion_a.public_ip
}

output "bastion_host_instance_id" {
  description = "Instance ID of the Bastion host"
  value       = aws_instance.bastion_a.id
}

output "app_server_a_private_ip" {
  description = "Private IP address of App Server A"
  value       = aws_instance.app_a.private_ip
}

output "app_server_a_instance_id" {
  description = "Instance ID of App Server A"
  value       = aws_instance.app_a.id
}

output "app_server_c_private_ip" {
  description = "Private IP address of App Server C"
  value       = aws_instance.app_c.private_ip
}

output "app_server_c_instance_id" {
  description = "Instance ID of App Server C"
  value       = aws_instance.app_c.id
}
