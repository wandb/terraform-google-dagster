output "dagster_user_deployment_manifest" {
  value = helm_release.dagster_user_deployment.manifest
}

output "dagster_service_manifest" {
  value = helm_release.dagster_service.manifest
}

# IAP example outputs
output "iap_ingress_ip" {
  description = "Global IP address for IAP-protected Dagster web UI (if IAP example is enabled)"
  value       = var.enable_iap_example ? google_compute_global_address.dagster_ip[0].address : null
}

output "iap_domain" {
  description = "Domain for IAP-protected access (if IAP example is enabled)"
  value       = var.enable_iap_example ? var.domain : null
}
