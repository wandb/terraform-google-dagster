terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}

resource "random_id" "default" {
  # 30 bytes ensures that enough characters are generated to satisfy the service account ID requirements, regardless of
  # the prefix.
  byte_length = 30
  prefix      = "${var.namespace}-"
}

resource "google_service_account" "default" {
  # Limit the string used to 30 characters.
  account_id   = substr(random_id.default.dec, 0, 30)
  display_name = "GKE node pool Service Account"
  description  = "Used by GKE node pools in ${var.namespace}."
}

resource "google_service_account_key" "default" {
  service_account_id = google_service_account.default.name

  depends_on = [google_service_account.default]
}

locals {
  roles = [
    "roles/monitoring.viewer",
    "roles/monitoring.metricWriter",
    "roles/logging.logWriter",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/autoscaling.metricsWriter"
  ]
}

resource "google_project_iam_member" "roles" {
  for_each = toset(local.roles)

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.default.email}"
}
