# Creates VPC network
resource "google_compute_network" "vpc" {
  name                    = "${var.namespace}-vpc"
  description             = "${var.namespace} VPC Network"
  auto_create_subnetworks = false
}

# VM instances and other resources to communicate with each other via internal,
# private IP addresses
resource "google_compute_subnetwork" "default" {
  name          = "${var.namespace}-subnet"
  ip_cidr_range = "10.10.0.0/16"
  network       = google_compute_network.vpc.self_link
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "${var.namespace}-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
