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

resource "google_service_account" "redis" {
  project      = "${var.project}"
  account_id   = "${var.service_account}"
  display_name = "${var.service_account}"
}

resource "google_storage_bucket" "config" {
  project       = "${var.project}"
  name          = "${var.config_bucket}"
  storage_class = "REGIONAL"
  location      = "${var.region}"
}

resource "google_storage_bucket_iam_binding" "config" {
  bucket      = "${google_storage_bucket.config.name}"
  role        = "roles/storage.objectViewer"
  members = ["serviceAccount:${google_service_account.redis.email}"]
}

data "google_compute_network" "default" {
  project = "${var.xpc_project}"
  name    = "${var.network}"
}

data "google_compute_subnetwork" "default" {
  project = "${var.xpc_project}"
  region  = "${var.region}"
  name    = "${var.subnetwork}"
}

resource "google_compute_firewall" "healthcheck" {
  project = "${var.project}"
  name    = "redis-healthcheck"
  network = "${data.google_compute_network.default.name}"
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }
  source_ranges  = ["35.191.0.0/16","130.211.0.0/22"]
  target_service_accounts = ["${google_service_account.redis.email}"]
}

resource "google_compute_firewall" "redis" {
  project = "${var.project}"
  name    = "redis-cluster"
  network = "${data.google_compute_network.default.name}"
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "tcp"
    ports    = ["6379","26379"]
  }
  source_service_accounts = ["${google_service_account.redis.email}"]
  target_service_accounts = ["${google_service_account.redis.email}"]
}

resource "google_compute_firewall" "client" {
  project = "${var.project}"
  name    = "redis-client"
  network = "${data.google_compute_network.default.name}"
  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }
  source_ranges  = ["${var.client_ip_range}"]
  target_service_accounts = ["${google_service_account.redis.email}"]
}

resource "google_project_iam_member" "redis_logs" {
  project = "${var.project}"
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.redis.email}"
}

resource "google_project_iam_member" "redis_metrics" {
  project = "${var.project}"
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.redis.email}"
}
