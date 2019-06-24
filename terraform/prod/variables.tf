variable "project" {
  type        = "string"
  description = "project id"
}

variable "region" {
  type        = "string"
  description = "Instance region"
  default     = "europe-west1"
}

variable "public_key_path" {
  type        = "string"
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  type        = "string"
  description = "Path to the private key used for provisioning"
}

variable "disk_image" {
  type        = "string"
  description = "Disk image name"
}

variable "app_disk_image" {
  type        = "string"
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable "db_disk_image" {
  type        = "string"
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable "remote_state_bucket_name" {
  type = "string"
  description = "GCS Bucket name for tfstate"
  default = "wirehead_tf_state"
}

variable "remote_state_bucket_prefix" {
  type = "string"
  description = "GCS Bucket prefix for tfstate"
  default = "terraform_prod_state"
}