resource "random_id" "default" {
  # 30 bytes ensures that enough characters are generated to satisfy the service account ID requirements, regardless of
  # the prefix.
  byte_length = 30
  prefix      = "${var.namespace}-"
}

resource "google_service_account" "default" {
  # Limit the string used to 30 characters.
  account_id   = substr(random_id.default.dec, 0, 30)
  display_name = var.namespace
  description  = "Service Account used by ${var.namespace}."
}

resource "google_service_account_key" "default" {
  service_account_id = google_service_account.default.name

  depends_on = [google_service_account.default]
}
