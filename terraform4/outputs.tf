output "working_url" {
  value = "http://${aws_instance.my_server.public_ip}:8080"
}

output "ssm_command" {
  value = "aws ssm start-session --target ${aws_instance.my_server.id}"
}

output "server_id" {
  value = aws_instance.my_server.id
}

output "server_ip" {
  value = aws_instance.my_server.public_ip
}
