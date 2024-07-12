output "service_account" {
  description = "Service account created to manage and authenticate services."
  value       = module.service_account.service_account
}

output "cluster_endpoint" {
  description = "Endpoint of provisioned Kubernetes cluster"
  value       = module.cluster.cluster_endpoint
}

output "cluster_id" {
  description = "Id of provisioned Kubernetes cluster"
  value       = module.cluster.cluster_id
}

output "cluster_ca_certificate" {
  description = "Cluster certificate of provisioned Kubernetes cluster"
  value       = module.cluster.cluster_ca_certificate
  sensitive   = true
}

output "storage_bucket_name" {
  description = "Name of provisioned Cloud Storage bucket"
  value       = module.storage.storage_bucket_name
}

output "cloudsql_database" {
  description = "Object containing connection parameters for provisioned CloudSQL database"
  value       = module.database.cloudsql_database
  sensitive   = true
}

output "registry_name" {
  description = "Name of provisioned Artifact Registry"
  value       = module.registry.registry_name
}

output "registry_location" {
  description = "Location of provisioned Artifact Registry"
  value       = module.registry.registry_location
}

output "registry_image_path" {
  description = "Docker image path of provisioned Artifact Registry"
  value       = module.registry.registry_image_path
}

output "registry_image_pull_secret" {
  description = "Name of Kubernetes secret containing Docker config with permissions to pull from private Artifact Registry repository"
  value       = module.registry.registry_image_pull_secret
}

output "network_name" {
  description = "Name of provisioned VPC network"
  value       = module.networking.network.name
}
