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

variable "dagster_version" {
  description = "Version of Dagster to deploy"
  type        = string
  default     = "0.14.3"
}

variable "dagster_deployment_image" {
  description = "Image name of user code deployment"
  type        = string
  default     = "user-code-example"
}

variable "dagster_deployment_tag" {
  description = "User code deployment tag of Dagster to deploy"
  type        = string
  default     = "latest"
}
