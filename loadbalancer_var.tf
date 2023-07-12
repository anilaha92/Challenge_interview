variable "publicip" {
  default = "PublicIPAddress"
}

variable "loadbalancer" {
  default = "testloadbalancer"
}


variable "BackEndAddressPool_name" {default = "BackEndAddressPool"}

variable "lb_frontend_port" {
  type = number
  default = 80
}
variable "lb_backend_port" {
  type = number
  default = 80
}