output "service_account" {
  value = module.service_account.service_account
}

output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
}

output "cluster_ca_certificate" {
  value     = module.cluster.cluster_ca_certificate
  sensitive = true
}

output "storage_bucket_name" {
  value = module.storage.storage_bucket_name
}

output "cloudsql_database" {
  value     = module.database.cloudsql_database
  sensitive = true
}

output "registry_image_path" {
  value = module.registry.registry_image_path
}

output "registry_image_pull_secret" {
  value = module.registry.registry_image_pull_secret
}
