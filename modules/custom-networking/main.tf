terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

# Data sources for existing custom networking
data "google_compute_network" "custom" {
  name    = basename(var.network_self_link)
  project = var.project_id
}

data "google_compute_subnetwork" "custom" {
  name    = basename(var.subnetwork_self_link)
  project = var.project_id
  region  = var.region
}

# Service networking connection for custom VPC (needed for CloudSQL private IP)
resource "google_compute_global_address" "private_ip_address" {
  name          = "${var.namespace}-custom-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.custom.id
  project       = var.project_id
}

resource "google_service_networking_connection" "default" {
  network                 = data.google_compute_network.custom.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]

  depends_on = [google_compute_global_address.private_ip_address]
}
