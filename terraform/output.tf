output "nginx_url" {
  description = "URL to check nginx"
  value       = "http://${var.vm_ip}:${var.nginx_port}"
}

output "container_id" {
  description = "ID of nginx container"
  value       = docker_container.nginx.id
}
