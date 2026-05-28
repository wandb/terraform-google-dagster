terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

resource "google_artifact_registry_repository" "default" {
  format        = "DOCKER"
  location      = var.location
  repository_id = "${var.namespace}-registry"

  cleanup_policies {
    id     = "delete-old-images"
    action = "DELETE"
    condition {
      older_than = "365d"
    }
  }
}

# Grants the GKE node service account read access to the registry.
# With GKE Workload Identity enabled on the cluster, the kubelet uses the node
# SA credentials to pull images without any imagePullSecrets.
resource "google_artifact_registry_repository_iam_member" "access" {
  project    = google_artifact_registry_repository.default.project
  location   = google_artifact_registry_repository.default.location
  repository = google_artifact_registry_repository.default.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.service_account.email}"

  depends_on = [google_artifact_registry_repository.default]
}
