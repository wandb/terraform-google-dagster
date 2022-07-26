variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "Google region"
  type        = string
}

variable "zone" {
  description = "Google zone"
  type        = string
}

variable "namespace" {
  description = "Namespace used as a prefix for all resources"
  type        = string
}

variable "deletion_protection" {
  description = "Indicates whether or not storage and databases have deletion protection enabled"
  type        = bool
  default     = true
}

variable "cloud_storage_bucket_location" {
  description = "Location to create cloud storage bucket in."
  type        = string
  default     = "US"
}

variable "cloudsql_postgres_version" {
  description = "The postgres version of the CloudSQL instance."
  type        = string
  default     = "POSTGRES_14"
}

variable "cloudsql_tier" {
  description = "The machine type to use"
  type        = string
  default     = "db-f1-micro"
}

variable "cloudsql_availability_type" {
  description = "The availability type of the Cloud SQL instance."
  type        = string
  default     = "ZONAL"
}

variable "cluster_compute_machine_type" {
  description = "Compute machine type to deploy cluster default nodes on."
  type        = string
  default     = "e2-standard-2"
}

variable "cluster_node_count" {
  description = "Number of nodes to create in cluster."
  type        = number
  default     = 2
}

variable "cluster_gpu_node_pool_max_node_count" {
  description = "Maximum number of nodes in the GPU NodePool."
  type        = number
  default     = 2
}

variable "cluster_gpu_node_pool_machine_type" {
  description = "Compute machine type to deploy cluster GPU nodes on."
  type        = string
  default     = "a2-highgpu-1g"
}

variable "cluster_gpu_node_pool_gpu_type" {
  description = "The accelerator type resource to expose to the instance."
  type        = string
  default     = "nvidia-tesla-v100"
}

variable "cluster_gpu_node_pool_gpu_count" {
  description = "The number of the guest accelerator cards exposed to the instance."
  type        = number
  default     = 2
}
