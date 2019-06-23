provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}


resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "europe-west1-b"
  # определим загрузочный диск
  tags = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  # определим сетевой интерфейс
  network_interface {
    network = "default"
    access_config {}
  }

  # определим metadata для инстанса
  metadata = {
    sshKeys = "appuser:${file(var.public_key_path)}"
  }

  # параметры подключения к инстансу
  connection {
    host        = "${google_compute_instance.app.network_interface.0.access_config.0.nat_ip}"
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  # systemd сервис для Puma Server
  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  # Скрипт деплоя приложения
  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}


resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"
  # указываем порты которые открываем
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # для каких адресов открываем доступ
  source_ranges = ["0.0.0.0/0"]
  # для каких тегов применимо правило
  target_tags = ["reddit-app"]
}


resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}