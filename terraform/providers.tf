provider "docker" {
  host = "ssh://student@${var.vm_ip}"
}
