output "registry" {
  description = "Artifact registry for user code deployment images."
  value       = google_artifact_registry_repository.default
}

output "docker_image_path" {
  description = "Host to point docker client to when fetching remote images."
  value       = "${google_artifact_registry_repository.default.location}-docker.pkg.dev/${google_artifact_registry_repository.default.project}/${google_artifact_registry_repository.default.repository_id}"
}

