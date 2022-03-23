variable "namespace" {
  type        = string
  description = "The namespace name used as a prefix for all resources created."
}

variable "network_connection" {
  description = "The private service networking connection that will connect database to the network."
  type        = object({ network = string })
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`."
  type        = bool
}

variable "cloudsql_postgres_version" {
  description = "The postgres version of the CloudSQL instance."
  type        = string
}

variable "cloudsql_tier" {
  description = "The CloudSQL machine tier to use."
  type        = string
}

variable "cloudsql_availability_type" {
  description = "The availability type of the CloudSQL instance."
  type        = string
}
