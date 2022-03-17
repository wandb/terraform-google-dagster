variable "namespace" {
  type        = string
  description = "The namespace name used as a prefix for all resources created."
}

variable "compute_machine_type" {
  type        = string
  description = "Compute machine type to deploy cluster nodes on."
}

variable "service_account" {
  description = "The service account associated with the GKE cluster instances that host Dagster."
  type        = object({ email = string, account_id = string })
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}

variable "subnetwork" {
  description = "Google Compute Engine subnetwork in which the cluster's instances are launched."
  type        = object({ self_link = string })
}
