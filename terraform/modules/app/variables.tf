variable "public_key_path" {
  type        = "string"
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  type        = "string"
  description = "Path to the private key used for provisioning"
}

variable "app_disk_image" {
  type = "string"
  description = "Disk image for reddit app"
  default = "reddit-app-base"
}
