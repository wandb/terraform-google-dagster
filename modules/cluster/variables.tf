variable "namespace" {
  description = "The namespace name used as a prefix for all resources created."
  type        = string
}

variable "project_id" {
  description = "GCP project id used to enable a workload identity pool."
  type        = string
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}

variable "subnetwork" {
  description = "Google Compute Engine subnetwork in which the cluster's instances are launched."
  type        = object({ self_link = string })
}
