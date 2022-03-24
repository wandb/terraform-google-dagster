resource "google_container_cluster" "default" {
  name            = "${var.namespace}-cluster"
  networking_mode = "VPC_NATIVE"
  network         = var.network.self_link
  subnetwork      = var.subnetwork.self_link

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/14"
    services_ipv4_cidr_block = "/19"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "STABLE"
  }

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "default" {
  name       = "default-node-pool"
  cluster    = google_container_cluster.default.id
  node_count = var.cluster_node_count

  node_config {
    machine_type    = var.cluster_compute_machine_type
    service_account = var.service_account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/bigtable.admin",
      "https://www.googleapis.com/auth/bigtable.data",
      "https://www.googleapis.com/auth/bigquery",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/pubsub",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/sqlservice.admin",
    ]
  }

  lifecycle {
    ignore_changes = [
      location
    ]
  }
}
