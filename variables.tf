/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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

# n1-highmem-2   2 vCPUs 13 GB
# n1-highmem-4   4 vCPUs 26 GB
# n1-highmem-8   8 vCPUs 52 GB
# n1-highmem-16  16 vCPUs 104 GB
# n1-highmem-32  32 vCPUs 208 GB
variable "instance_type" {
  default = "n1-highmem-2"
}

variable "pass" {
  default = "BYdDm2D5aj1L28e8dpvn36ec039qe938dc3f"
}

variable "client_ip_range" {
  default = "10.0.0.0/8"
}