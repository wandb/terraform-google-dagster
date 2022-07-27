# Creates VPC network
resource "google_compute_network" "default" {
  name                    = "${var.namespace}-vpc"
  description             = "${var.namespace} VPC Network"
  auto_create_subnetworks = false
  project                 = var.project

  # A global routing mode can have an unexpected impact on load balancers; always use a regional mode
  routing_mode = "REGIONAL"
}

# VM instances and other resources to communicate with each other via internal,
# private IP addresses
resource "google_compute_subnetwork" "default" {
  name          = "${var.namespace}-subnet"
  ip_cidr_range = "10.10.0.0/16"
  network       = google_compute_network.default.self_link
  project       = var.project
  region        = var.region

  # When enabled, VMs in this subnetwork without external IP addresses can access Google APIs 
  # and services by using Private Google Access.
  private_ip_google_access = true

  depends_on = [google_compute_network.default]
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "${var.namespace}-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.default.id
  project       = var.project

  depends_on = [google_compute_network.default]
}

resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]

  depends_on = [google_compute_network.default, google_compute_global_address.private_ip_address]
}
