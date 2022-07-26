variable "namespace" {
  description = "The namespace name used as a prefix for all resources created."
  type        = string
}

variable "project_id" {
  description = "GCP project id used to enable a workload identity pool."
  type        = string
}

variable "cluster_compute_machine_type" {
  description = "Compute machine type to deploy cluster default nodes on."
  type        = string
}

variable "cluster_node_count" {
  description = "Number of nodes to create in cluster."
  type        = number
}

variable "cluster_gpu_node_pool_max_node_count" {
  description = "Maximum number of nodes in the GPU NodePool."
  type        = string
}

variable "cluster_gpu_node_pool_machine_type" {
  description = "Compute machine type to deploy cluster GPU nodes on."
  type        = string
}

variable "cluster_gpu_node_pool_gpu_type" {
  description = "The accelerator type resource to expose to the instance."
  type        = string
}

variable "cluster_gpu_node_pool_gpu_count" {
  description = "The number of the guest accelerator cards exposed to the instance."
  type        = string
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
