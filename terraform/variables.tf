variable "vm_ip" {
  description = "IP of the VM"
  type        = string
  default     = "111.88.162.117"
}

variable "nginx_port" {
  description = "External port for nginx"
  type        = number
  default     = 8090
}
