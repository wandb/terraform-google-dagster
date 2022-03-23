output "dagster_user_deployment_manifest" {
  value = helm_release.dagster_user_deployment.manifest
}

output "dagster_service_manifest" {
  value = helm_release.dagster_service.manifest
}
