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
