variable "namespace" {
  description = "The namespace used as a prefix for all resources created."
  type        = string
}

variable "service_account" {
  description = "The service account used to manage application services."
  type        = object({ email = string, account_id = string })
}

variable "cloud_storage_bucket_location" {
  description = "The location of the bucket"
  type        = string
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`."
  type        = bool
}
