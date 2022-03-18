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

### Needed for Helm chart values

output "docker_image_path" {
  value = module.registry.docker_image_path
}

output "database_host" {
  value = module.database.private_ip_address
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
