output "service_account" {
  value = module.service_account.sa
}

output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
}

output "cluster_ca_certificate" {
  value     = module.cluster.cluster_ca_certificate
  sensitive = true
}

output "bucket_name" {
  value = module.storage.bucket_name
}

output "network_id" {
  value = module.networking.network.id
}

output "database" {
  value     = module.database.database
  sensitive = true
}

output "registry_image_path" {
  value = module.registry.image_path
}

output "private_docker_config_secret" {
  value = module.kubernetes_config.private_docker_config_secret
}

output "database_name" {
  value = module.database.database_name
}

output "database_username" {
  value = module.database.username
}

output "database_password" {
  sensitive = true
  value     = module.database.password
}
