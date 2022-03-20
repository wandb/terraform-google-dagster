variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "region" {
  type        = string
  description = "Google region"
}

variable "zone" {
  type        = string
  description = "Google zone"
}

variable "namespace" {
  type        = string
  description = "Namespace used as a prefix for all resources"
}

variable "compute_machine_type" {
  type        = string
  default     = "e2-standard-2"
  description = "Compute machine type to deploy cluster nodes on."
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Indicates whether or not storage and databases have deletion protection enabled"
}
