output "registry" {
  description = "Artifact registry for user code deployment images."
  value       = google_artifact_registry_repository.default
}

