mock_provider "google" {}

variables {
  namespace                        = "dagster-test"
  project_id                       = "test-project"
  domain                           = "example"
  cluster_compute_machine_type     = "e2-standard-2"
  cluster_node_pool_max_node_count = 2
  service_account                  = { email = "dagster@test-project.iam.gserviceaccount.com" }
  network                          = { self_link = "projects/test-project/global/networks/test" }
  subnetwork                       = { self_link = "projects/test-project/regions/us-central1/subnetworks/test" }
}

run "workload_identity" {
  command = plan

  assert {
    condition     = google_container_cluster.default.workload_identity_config[0].workload_pool == "${var.project_id}.svc.id.goog"
    error_message = "The cluster must enable Workload Identity for the project."
  }

  assert {
    condition     = google_container_node_pool.default.node_config[0].workload_metadata_config[0].mode == "GKE_METADATA"
    error_message = "The default node pool must use GKE_METADATA."
  }
}

run "master_authorized_networks_unset_by_default" {
  command = plan

  assert {
    condition     = length(google_container_cluster.default.master_authorized_networks_config) == 0
    error_message = "The module must not set master authorized networks when no CIDRs are given."
  }
}

run "master_authorized_networks_restricts_endpoint" {
  command = plan

  variables {
    master_authorized_cidrs = ["192.0.2.0/26", "198.51.100.0/28"]
  }

  assert {
    condition     = toset([for b in google_container_cluster.default.master_authorized_networks_config[0].cidr_blocks : b.cidr_block]) == toset(["192.0.2.0/26", "198.51.100.0/28"])
    error_message = "The cluster must allow exactly the given CIDRs."
  }

  assert {
    condition     = google_container_cluster.default.master_authorized_networks_config[0].gcp_public_cidrs_access_enabled == false
    error_message = "Google Cloud public IP ranges must not get control-plane access."
  }
}

run "master_authorized_networks_rejects_invalid_cidr" {
  command = plan

  variables {
    master_authorized_cidrs = ["not-a-cidr"]
  }

  expect_failures = [var.master_authorized_cidrs]
}
