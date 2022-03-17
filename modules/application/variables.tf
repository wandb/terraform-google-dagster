variable "dagster_version" {
  type        = string
  default     = "0.14.3"
  description = "Version of Dagster to deploy"
}

variable "dagster_deployment_image" {
  type        = string
  description = "Image name of user code deployment"
}

variable "dagster_deployment_tag" {
  type        = string
  default     = "latest"
  description = "User code deployment tag of Dagster to deploy"
}

variable "deployment_port" {
  type        = number
  default     = 3030
  description = "gRPC port to expose code deployment code."
}

variable "registry" {
  type        = object({ id = string, location = string, repository_id = string, project = string })
  description = "Artifact registry used for pulling code deployment images."
}

variable "service_account_json" {
  type        = string
  description = "Service account json key to grant permissions for registry image pulling."
}

variable "database_host" {
  type        = string
  description = "Host of Dagster metadata database instance."
}

variable "database_username" {
  type        = string
  description = "User for Dagster metadata database instance."
}

variable "database_password" {
  type        = string
  sensitive   = true
  description = "Password for Dagster metadata database instance."
}

variable "database_name" {
  type        = string
  description = "Name of Dagster metadata database instance."
}
