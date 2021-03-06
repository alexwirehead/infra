terraform {
  backend "gcs" {
    bucket  = "wirehead_tf_state"
    prefix  = "terraform_prod_state"
  }
}


provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}


module "app" {
  source           = "../modules/app"
  app_disk_image   = "${var.app_disk_image}"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
}


module "db" {
  source          = "../modules/db"
  db_disk_image   = "${var.db_disk_image}"
  public_key_path = "${var.public_key_path}"
}

module "vps" {
  source        = "../modules/vpc"
  source_ranges = ["194.176.96.247/32"]
}