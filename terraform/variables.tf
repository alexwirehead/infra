variable "project" {
  type = "string"
  description = "project id"
}

variable "region" {
  type = "string"
  description = "Instance region"
  default = "europe-west1"
}

variable "public_key_path" {
  type = "string"
  description = "Path to the public key used for ssh access"
}

variable "disk_image" {
  type = "string"
  description = "Disk image name"
}