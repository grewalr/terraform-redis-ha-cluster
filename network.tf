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

data "google_compute_network" "default" {
  project = "${var.xpc_project}"
  name    = "${var.network}"
}

# projects/_/regions/_/subnetworks/_
data "google_compute_subnetwork" "default" {
  project = "${var.xpc_project}"
  region  = "${var.region}"
  name    = "${var.subnetwork}"
}

resource "google_compute_address" "redis" {
  project      = "${var.project}"
  name         = "redis"
  subnetwork   = "${data.google_compute_subnetwork.default.self_link}"
  address_type = "INTERNAL"
  region       = "${var.region}"
}

resource "google_compute_health_check" "default" {
  project             = "${var.project}"
  name                = "redis"
  timeout_sec         = 2
  check_interval_sec  = 8
  healthy_threshold   = 1
  unhealthy_threshold = 3

  tcp_health_check {
    port = "6379"
  }
}