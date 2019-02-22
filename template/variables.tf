variable "cluster_name" {
  default = "mycluster"
}

variable "project" {
  default = "myproject"
}

variable "region" {
  default = "us-east1"
}

variable "zone_a" {
  default = "us-east1-b" 
}

variable "zone_b" {
  default = "us-east1-c" 
}

variable "zone_c" {
  default = "us-east1-d" 
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

variable "service_account" {
  default = "redis-server"
}

variable "config_bucket" {
  default = "mybucket"
}

variable "health_check" {
  default = "redis"
}

# n1-highmem-2   2 vCPUs 13 GB
# n1-highmem-4   4 vCPUs 26 GB
# n1-highmem-8   8 vCPUs 52 GB
# n1-highmem-16  16 vCPUs 104 GB
# n1-highmem-32  32 vCPUs 208 GB
variable "instance_type" {
  default = "n1-highmem-2"
}

variable "disk_size_gb" {
  default = 128
}

variable "pass" {
  default = "changeit"
}
