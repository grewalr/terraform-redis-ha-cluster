variable "project" {
  default = "myproject"
}

variable "region" {
  default = "us-east1"
}

variable "service_account" {
  default = "redis-server"
}

variable "config_bucket" {
  default = "mybucket"
}

variable "xpc_project" {
  default = "myproject"
}

variable "network" {
  default = "default"
}

variable "subnetwork" {
  default = "default"
}

variable "client_ip_range" {
  default = "10.0.0.0/8"
}
