locals {
  member = "serviceAccount:${var.service_account.email}"
}

resource "random_pet" "suffix" {
  length = 2
}

resource "google_storage_bucket" "file_storage" {
  name     = "${var.namespace}-storage"
  location = var.bucket_location

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
}

resource "google_storage_bucket_iam_member" "legacy_bucket_reader" {
  bucket = google_storage_bucket.file_storage.name
  member = local.member
  role   = "roles/storage.legacyBucketReader"
}
