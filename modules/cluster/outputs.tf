output "cluster_id" {
  value = google_container_cluster.default.id
}

output "cluster_endpoint" {
  value = google_container_cluster.default.endpoint
}

output "cluster_ca_certificate" {
  value     = google_container_cluster.default.master_auth.0.cluster_ca_certificate
  sensitive = true
}

output "cluster_self_link" {
  value = google_container_cluster.default.self_link
}

output "node_pool" {
  value = google_container_node_pool.default
}
