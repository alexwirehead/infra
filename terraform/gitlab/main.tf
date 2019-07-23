provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}


data "google_compute_image" "gitlab_image" {
  family = "centos-7"
}


resource "google_compute_instamce" "gitlab" {
  name = "${var.machine_name}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  tags = ["gitlab"]
  
  boot_disk {
    initialize_params {
      size = "${var.disk_size}"
      image = "${data.google_compute_image.gitlab_image.self_link}"
    }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.gitlab-ip.address}"
    }
  }
  metadata = {
    sshKeys = "appuser:${file(var.public_key_path)}"
  }
}


resource "google_compute_firewall" "firewall_gitlab" {
  name    = "allow-gitlab-default"
  network = "default"
  # указываем порты которые открываем
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  # для каких адресов открываем доступ
  source_ranges = ["0.0.0.0/0"]
  # для каких тегов применимо правило
  target_tags = ["gitlab"]
}


resource "google_compute_address" "gitlab_ip" {
  name = "gitlab-ip"
}