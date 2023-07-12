variable "vmsize" {
  default  = "Standard_DS1_v2"
}

variable "env" {
  default  = "interview"
}

variable "diskname" {
  default  = "OSdisk"
}

variable "username" {
  default  = "interviewuser"
}

variable "password" {
  default  = ""
  sensitive = true
}

variable "image_publisher" {default = "Canonical"}

variable "image_offer" {default = "UbuntuServer"}

variable "image_sku" {default = "18.04-LTS"}

variable "managed_disk_type" {default = "Standard_LRS"}

