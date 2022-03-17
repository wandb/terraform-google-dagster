variable "namespace" {
  type        = string
  description = "The namespace used as a prefix for all resources created."
}

variable "service_account" {
  description = "The service account used to manage application services."
  type        = object({ email = string, account_id = string })
}

variable "bucket_location" {
  type    = string
  default = "US"
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`."
  type        = bool
  default     = true
}
