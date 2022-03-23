variable "namespace" {
  description = "The namespace name used as a prefix for all resources created."
  type        = string
}

variable "cluster_compute_machine_type" {
  description = "Compute machine type to deploy cluster nodes on."
  type        = string
}

variable "cluster_node_count" {
  description = "Number of nodes to create in cluster."
  type        = number
}

variable "service_account" {
  description = "The service account associated with the GKE cluster instances that host Dagster."
  type        = object({ email = string, account_id = string })
}

variable "service_account_json" {
  type        = string
  description = "Service account json key to grant permissions for registry image pulling."
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}

variable "subnetwork" {
  description = "Google Compute Engine subnetwork in which the cluster's instances are launched."
  type        = object({ self_link = string })
}

variable "registry" {
  type        = object({ id = string })
  description = "Artifact registry used for pulling code deployment images."
}
