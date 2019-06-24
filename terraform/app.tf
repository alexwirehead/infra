resource "google_compute_instance" "app" {
  name = "reddit-app"
  machine_type = "g1-small"
  zone = "europe-west1-b"
  tags = ["reddit-app"]
  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }
  network_interface {
    network = "default"
    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }
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


resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}