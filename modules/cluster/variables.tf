variable "namespace" {
  description = "The namespace name used as a prefix for all resources created."
  type        = string
}

variable "project_id" {
  description = "GCP project id used to enable a workload identity pool."
  type        = string
}

variable "region" {
  description = "Google region"
  type        = string
}

variable "cluster_compute_machine_type" {
  description = "Compute machine type to deploy cluster nodes on."
  type        = string
}

variable "cluster_node_pool_max_node_count" {
  description = "Max number of nodes cluster can scale up to."
  type        = number
}

variable "cluster_monitoring_components" {
  description = "Components to enable in the GKE monitoring stack."
  type        = list(string)
  default     = []
}

variable "service_account" {
  description = "The service account associated with the GKE cluster instances that host Dagster."
  type        = object({ email = string })
}

variable "network" {
  description = "Google Compute Engine network to which the cluster is connected."
  type        = object({ self_link = string })
}

variable "subnetwork" {
  description = "Google Compute Engine subnetwork in which the cluster's instances are launched."
  type        = object({ self_link = string })
}

variable "domain" {
  description = "The domain in which your Google Groups are defined."
  type        = string
}

variable "enable_private_cluster" {
  description = "Enable private cluster configuration"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the hosted master network. If null, GKE will auto-assign."
  type        = string
  default     = null
}

variable "authorized_networks" {
  description = "List of authorized networks for accessing the master endpoint"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

variable "cluster_secondary_range_name" {
  description = "Name of the secondary range for cluster pods. If null, GKE will auto-create."
  type        = string
  default     = null
}

variable "services_secondary_range_name" {
  description = "Name of the secondary range for cluster services. If null, GKE will auto-create."
  type        = string
  default     = null
}
