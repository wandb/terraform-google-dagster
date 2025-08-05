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

variable "domain" {
  description = "The domain in which your Google Groups are defined."
  type        = string
  default     = "example"
}

variable "custom_networking" {
  description = "Custom networking configuration for shared VPC scenarios"
  type = object({
    network_self_link      = optional(string)
    subnetwork_self_link   = optional(string)
    enable_private_cluster = optional(bool, false)
    master_ipv4_cidr_block = optional(string)
    authorized_networks = optional(list(object({
      cidr_block   = string
      display_name = string
    })), [])
  })
  default = {}
}

variable "oauth_client_id" {
  description = "OAuth 2.0 client ID for IAP (required if enable_iap_example is true)"
  type        = string
  default     = null
}

variable "oauth_client_secret" {
  description = "OAuth 2.0 client secret for IAP (required if enable_iap_example is true)"
  type        = string
  default     = null
  sensitive   = true
}

variable "iap_allowed_domains" {
  description = "Domains allowed to access through IAP"
  type        = list(string)
  default     = []
}

variable "iap_allowed_users" {
  description = "Users allowed to access through IAP"
  type        = list(string)
  default     = []
}
