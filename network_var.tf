variable "project" {
  default = "interview"
}

variable "region" {
  default = "East US"
}

variable "vnet_cidr" {
  type = list
  default = ["10.0.0.0/16"]
}

variable "subnet2_address_prefixes" {
  type = list
  default = ["10.0.2.0/24"]
}
variable "subnet3_address_prefixes" {
  type = list
  default = ["10.0.3.0/24"]
}
variable "sub3_service_endpoints" {
  type = list
  default = ["Microsoft.Storage"]
}


