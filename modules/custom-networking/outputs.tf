output "network" {
  value       = data.google_compute_network.custom
  description = "The custom network."
}

output "subnetwork" {
  value       = data.google_compute_subnetwork.custom
  description = "The custom subnetwork."
}

output "connection" {
  description = "The private connection between the custom network and GCP services."
  value       = google_service_networking_connection.default
}
