terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

resource "google_container_cluster" "default" {
  name            = "${var.namespace}-cluster"
  networking_mode = "VPC_NATIVE"
  network         = var.network.self_link
  subnetwork      = var.subnetwork.self_link

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/14"
    services_ipv4_cidr_block = "/19"
  }

  authenticator_groups_config {
    security_group = "gke-security-groups@${var.domain}.com"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "STABLE"
  }

  monitoring_config {
    enable_components = var.cluster_monitoring_components
  }

  remove_default_node_pool = true
  initial_node_count       = 1

  # Private cluster configuration
  dynamic "private_cluster_config" {
    for_each = var.enable_private_cluster ? [1] : []
    content {
      enable_private_nodes    = true
      enable_private_endpoint = false
      master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    }
  }

  # Master authorized networks
  dynamic "master_authorized_networks_config" {
    for_each = length(var.authorized_networks) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.authorized_networks
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  # Disable client certificate authentication, which reduces the attack surface
  # for the cluster by disabling this deprecated feature. It defaults to false,
  # but this will make it explicit and quiet some security tooling.
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  lifecycle {
    ignore_changes = [
      # We are relying on the release channel to maintain version upgrades
      node_version
    ]
  }
}

resource "google_container_node_pool" "default" {
  name    = "default-node-pool"
  cluster = google_container_cluster.default.id

  autoscaling {
    min_node_count = 1
    max_node_count = var.cluster_node_pool_max_node_count
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type    = var.cluster_compute_machine_type
    service_account = var.service_account.email
  }

  network_config {
    # Isolate nodes from the internet by default. Internet access is granted with NAT.
    enable_private_nodes = true
  }

  lifecycle {
    ignore_changes = [
      location,
      version
    ]
  }
}
