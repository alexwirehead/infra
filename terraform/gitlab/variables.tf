variable "project" {
  type = "string"
  description = "GPC project id"
  default = "infra-244406"
}

variable "region" {
  type        = "string"
  description = "Instance region"
  default     = "europe-west1"
}

variable "machine_name" {
  type = "string"
  description = "GCP instance name"
  default = "gitlab"
}

variable "machine_type" {
  type = "string"
  description = "GCP custom machine type"
  default = "custom-2-3840"
}

variable "disk_size" {
  description = "GCP default disk size"
  default = 100
}

variable "zone" {
  type = "string"
  description = "GCP default region"
  default = "europe-west1-b"
}

variable "public_key_path" {
  type = "string"
  description = "GCP public_key_path"
  default = "~/.ssh/appuser.pub"
}
