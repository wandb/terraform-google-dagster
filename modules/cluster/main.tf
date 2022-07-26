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

  # Disable client certificate authentication, which reduces the attack surface
  # for the cluster by disabling this deprecated feature. It defaults to false,
  # but this will make it explicit and quiet some security tooling.
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
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
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  lifecycle {
    ignore_changes = [
      location
    ]
  }
}

resource "google_container_node_pool" "gpu" {
  name    = "gpu-node-pool"
  cluster = google_container_cluster.default.id
  autoscaling {
    max_node_count = var.cluster_gpu_node_pool_max_node_count
    min_node_count = 0
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  node_config {
    machine_type    = var.cluster_gpu_node_pool_machine_type
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
    guest_accelerator {
      type  = var.cluster_gpu_node_pool_gpu_type
      count = var.cluster_gpu_node_pool_gpu_count
    }
  }

  lifecycle {
    ignore_changes = [
      location
    ]
  }
}
