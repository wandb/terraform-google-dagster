resource "google_artifact_registry_repository" "default" {
  provider      = google-beta
  format        = "DOCKER"
  location      = var.location
  repository_id = var.namespace
}

# Grants pull access for the registry to the project's service account
# This service account will be used by the Kubernetes cluster when accessing
# code deployment images in the private repository.
resource "google_artifact_registry_repository_iam_member" "access" {
  provider   = google-beta
  project    = google_artifact_registry_repository.default.project
  location   = google_artifact_registry_repository.default.location
  repository = google_artifact_registry_repository.default.name
  role       = "roles/viewer"
  member     = "serviceAccount:${var.service_account.email}"
}
