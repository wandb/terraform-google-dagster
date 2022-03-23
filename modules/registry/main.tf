resource "google_artifact_registry_repository" "default" {
  provider      = google-beta
  format        = "DOCKER"
  location      = var.location
  repository_id = "${var.namespace}-registry"
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

  depends_on = [google_artifact_registry_repository.default]
}

# Grants permissions to pull images from Artifact Registry.
# This must be used as an imagePullSecret to access private images.
resource "kubernetes_secret" "image_pull_secret" {
  metadata {
    name = "artifact-registry"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://${google_artifact_registry_repository.default.id}-docker.pkg.dev" = {
          auth = "${base64encode("_json_key:${var.service_account_credentials}")}"
        }
      }
    })
  }

  type       = "kubernetes.io/dockerconfigjson"
  depends_on = [google_artifact_registry_repository_iam_member.access]
}
