resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_network" "app_net" {
  name = "app_net"
}

resource "docker_volume" "nginx_data" {
  name = "nginx_data"
}

resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.app_net.name
  }

  volumes {
    volume_name    = docker_volume.nginx_data.name
    container_path = "/usr/share/nginx/html"
  }

  ports {
    internal = 80
    external = var.nginx_port
  }

  restart = "unless-stopped"
}
