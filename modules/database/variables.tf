variable "namespace" {
  type        = string
  description = "The namespace name used as a prefix for all resources created."
}

variable "network_connection" {
  description = "The private service networking connection that will connect database to the network."
  type        = object({ network = string })
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
}

variable "tier" {
  type    = string
  default = "db-f1-micro"
}

variable "availability_type" {
  type    = string
  default = "ZONAL"
}
