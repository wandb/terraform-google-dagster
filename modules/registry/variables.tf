variable "namespace" {
  type        = string
  description = "The namespace used as a prefix for all resources created."
}

variable "location" {
  type        = string
  description = "The location to host Artifact registry repository in."
}

variable "service_account" {
  type = object({ email = string })

}
