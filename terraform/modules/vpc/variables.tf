variable "source_ranges" {
  type    = list(string)
  description = "Allow IP address"
  default = ["0.0.0.0/0"]
}