resource "google_container_cluster" "default" {
  name            = "${var.namespace}-cluster"
  networking_mode = "VPC_NATIVE"
  network         = var.network.self_link
  subnetwork      = var.subnetwork.self_link

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/14"
    services_ipv4_cidr_block = "/19"
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
  node_count = 2

  node_config {
    machine_type    = var.compute_machine_type
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

# Grants user code deployment the permissions to pull images from Artifact Registry
resource "kubernetes_secret" "artifact_registry" {
  metadata {
    name = "artifact-registry"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://${var.registry.id}-docker.pkg.dev" = {
          auth = "${base64encode("_json_key:${var.service_account_json}")}"
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"

  depends_on = [google_container_cluster.default]
}
