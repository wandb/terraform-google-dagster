locals {
  member = "serviceAccount:${var.service_account.email}"
}

resource "random_pet" "suffix" {
  length = 2
}

resource "google_storage_bucket" "file_storage" {
  name     = "${var.namespace}-storage-${random_pet.suffix}"
  location = var.cloud_storage_bucket_location

  uniform_bucket_level_access = true
  force_destroy               = !var.deletion_protection

  cors {
    method          = ["GET", "HEAD", "PUT"]
    response_header = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "google_storage_bucket_iam_member" "file_storage_object_admin" {
  bucket = google_storage_bucket.file_storage.name
  member = local.member
  role   = "roles/storage.objectAdmin"

  depends_on = [google_storage_bucket.file_storage]
}
