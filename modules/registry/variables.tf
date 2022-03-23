variable "namespace" {
  description = "The namespace used as a prefix for all resources created."
  type        = string
}

variable "location" {
  description = "The location to host Artifact registry repository in."
  type        = string
}

variable "service_account" {
  description = "Service account used to grant registry IAM membership."
  type        = object({ email = string })
}

variable "service_account_credentials" {
  description = "Service account json key to grant permissions for registry image pulling."
  type        = string
}
