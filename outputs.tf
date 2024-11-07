output "instance_id" {
  value       = aws_instance.this.id
  description = "The ID of the EC2 instance"
}

output "instance_public_ip" {
  value       = aws_instance.this.public_ip
  description = "The public IP of the EC2 instance"
}

output "instance_private_ip" {
  value       = aws_instance.this.private_ip
  description = "The private IP of the EC2 instance"
}