variable "namespace" {
  description = "The application name used as a prefix for all resources created."
  type        = string
}
variable "project" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "Google region"
  type        = string
}