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

provider "google-beta" {
  # https://github.com/terraform-providers/terraform-provider-google-beta/blob/master/google-beta/
  #credentials = "${file("account.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

locals {
  runid = "${substr(uuid(),0,4)}"
}

resource "google_compute_instance_template" "static" {
  project              = "${var.project}"
  name                 = "redis0-${local.runid}"
  description          = "redis instance template"
  instance_description = "Redis Server"
  machine_type         = "${var.instance_type}"
  can_ip_forward       = false
  tags                 = ["redis"]

  labels = {
    template = "tf-redis"
  }

  metadata {
    startup-script = "${data.template_file.startup.rendered}"
  }

  disk {
    source_image = "debian-cloud/debian-9"
    disk_size_gb = 128
    type         = "pd-standard"
  }

  network_interface {
    subnetwork         = "${data.google_compute_subnetwork.default.self_link}"
    subnetwork_project = "${data.google_compute_subnetwork.default.project}"
    network_ip = "${google_compute_address.redis.address}"
  }

  service_account {
    email  = "${google_service_account.redis.email}"
    scopes = ["cloud-platform"]
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_template" "ephemeral" {
  project              = "${var.project}"
  name                 = "redis1-${local.runid}"
  description          = "redis instance template"
  instance_description = "Redis Server"
  machine_type         = "${var.instance_type}"
  can_ip_forward       = false
  tags                 = ["redis"]

  labels = {
    template = "tf-redis"
  }

  metadata {
    startup-script = "${data.template_file.startup.rendered}"
  }

  disk {
    source_image = "debian-cloud/debian-9"
    disk_size_gb = 128
    type         = "pd-standard"
  }

  network_interface {
    subnetwork         = "${data.google_compute_subnetwork.default.self_link}"
    subnetwork_project = "${data.google_compute_subnetwork.default.project}"
  }

  service_account {
    email  = "${google_service_account.redis.email}"
    scopes = ["cloud-platform"]
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "redis0" {
  provider           = "google-beta"
  project            = "${var.project}"
  name               = "redis0"
  base_instance_name = "redis0"
  zone               = "${var.zone_a}"
  target_size        = 1
  version {
    name              = "v1"
    instance_template = "${google_compute_instance_template.static.self_link}"
  }
  update_policy {
    minimal_action        = "REPLACE"
    type                  = "PROACTIVE"
    max_unavailable_fixed = "1"
  }
  auto_healing_policies {
    health_check      = "${google_compute_health_check.default.self_link}"
    initial_delay_sec = 300
  }
}

resource "google_compute_instance_group_manager" "redis1" {
  provider           = "google-beta"
  project            = "${var.project}"
  name               = "redis1"
  base_instance_name = "redis1"
  zone               = "${var.zone_b}"
  target_size        = 1
  version {
    name              = "v1"
    instance_template = "${google_compute_instance_template.ephemeral.self_link}"
  }
  update_policy {
    minimal_action        = "REPLACE"
    type                  = "PROACTIVE"
    max_unavailable_fixed = "1"
  }
  auto_healing_policies {
    health_check      = "${google_compute_health_check.default.self_link}"
    initial_delay_sec = 300
  }
}

resource "google_compute_instance_group_manager" "redis2" {
  provider           = "google-beta"
  project            = "${var.project}"
  name               = "redis2"
  base_instance_name = "redis2"
  zone               = "${var.zone_c}"
  target_size        = 1
  version {
    name              = "v1"
    instance_template = "${google_compute_instance_template.ephemeral.self_link}"
  }
  update_policy {
    minimal_action        = "REPLACE"
    type                  = "PROACTIVE"
    max_unavailable_fixed = "1"
  }
  auto_healing_policies {
    health_check      = "${google_compute_health_check.default.self_link}"
    initial_delay_sec = 300
  }
}