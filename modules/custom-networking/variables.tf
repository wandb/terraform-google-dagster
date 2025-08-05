variable "namespace" {
  type        = string
  description = "The namespace name used as a prefix for all resources created."
}

variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "Google region"
  type        = string
}

variable "network_self_link" {
  description = "Self link of the existing VPC network"
  type        = string
}

variable "subnetwork_self_link" {
  description = "Self link of the existing subnetwork"
  type        = string
}
