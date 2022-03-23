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
  description = "Compute machine type to deploy cluster nodes on."
  type        = string
  default     = "e2-standard-2"
}

variable "cluster_node_count" {
  description = "Number of nodes to create in cluster."
  type        = number
  default     = 2
}
