output "credentials" {
  value       = base64decode(google_service_account_key.main.private_key)
  description = "The private key of the service account."
}

output "sa" {
  value       = google_service_account.main
  description = "The service account."
}
