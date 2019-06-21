provider "google" {
  project = "infra-244406"
  region = "europe-west1"
  
}

resource "google_compute_instance" "app" {
  name = "reddit-app"
  machine_type = "g1-small"
  zone = "europe-west1-b"
  # определим загрузочный диск
  boot_disk {
    initialize_params {
      image = "reddit-base-1561099838"
    }
  }
  # определим сетевой интерфейс
  network_interface {
    network = "default"
    access_config {}
  }
  # определим metadata для инстанса
  metadata = {
    sshKeys = "appuser:${file("~/.ssh/appuser.pub")}"
  }
  
}