resource "google_container_cluster" "default" {
  name            = "${var.namespace}-cluster"
  networking_mode = "VPC_NATIVE"
  network         = var.network.self_link
  subnetwork      = var.subnetwork.self_link

  # Autopilot is a new mode of operation in Google Kubernetes Engine (GKE)
  # that is designed to reduce the operational cost of managing clusters,
  # optimize your clusters for production, and yield higher workload
  # availability.
  # https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview
  enable_autopilot   = true
  min_master_version = "1.23.4-gke.1600"

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/14"
    services_ipv4_cidr_block = "/19"
  }

  # enable workload identiy pools for recommended permissioning practices
  # read more about this here: https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  initial_node_count = 1
}
