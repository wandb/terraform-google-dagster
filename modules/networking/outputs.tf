output "network" {
  value       = google_compute_network.default
  description = "The network."
}

output "subnetwork" {
  value       = google_compute_subnetwork.default
  description = "The subnetwork."
}

output "connection" {
  description = "The private connection between the network and GCP services."
  value       = google_service_networking_connection.default
}
