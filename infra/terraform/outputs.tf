output "server_public_ip" {
  description = "The Public IP of the newly created server"
  value       = aws_instance.app_server.public_ip
}

output "website_url" {
  description = "The HTTP URL (Configure DNS A-Record to point here)"
  value       = "http://${aws_instance.app_server.public_ip}"
}
