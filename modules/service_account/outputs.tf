output "service_account_credentials" {
  value       = base64decode(google_service_account_key.default.private_key)
  description = "The private key of the service account."
}

output "service_account" {
  value       = google_service_account.default
  description = "The service account."
}
