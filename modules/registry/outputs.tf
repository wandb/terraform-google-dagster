output "registry" {
  description = "Artifact registry for user code deployment images."
  value       = google_artifact_registry_repository.default
}

output "image_path" {
  description = "Path to registry repository images (ex: example_repo-docker.pkg.dev/my-project/dagster-images)"
  value       = "${google_artifact_registry_repository.default.location}-docker.pkg.dev/${google_artifact_registry_repository.default.project}/${google_artifact_registry_repository.default.repository_id}"
}
