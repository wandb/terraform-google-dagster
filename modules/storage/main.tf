terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.30"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}

locals {
  member = "serviceAccount:${var.service_account.email}"
}

resource "random_pet" "suffix" {
  length = 1
}

resource "google_storage_bucket" "file_storage" {
  name     = "${var.namespace}-storage-${random_pet.suffix.id}"
  location = var.cloud_storage_bucket_location

  uniform_bucket_level_access = true
  force_destroy               = !var.deletion_protection

  cors {
    method          = ["GET", "HEAD", "PUT"]
    response_header = ["ETag"]
    max_age_seconds = 3000
  }

  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket_iam_member" "file_storage_object_admin" {
  bucket = google_storage_bucket.file_storage.name
  member = local.member
  role   = "roles/storage.objectAdmin"

  depends_on = [google_storage_bucket.file_storage]
}
