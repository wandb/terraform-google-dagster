output "service_account" {
  value = module.service_account.sa
}

output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
}

output "bucket_name" {
  value = module.storage.bucket_name
}

output "registry_id" {
  value = module.registry.registry.id
}

output "network_id" {
  value = module.networking.network.id
}

output "database_private_ip" {
  value = module.database.private_ip_address
}
