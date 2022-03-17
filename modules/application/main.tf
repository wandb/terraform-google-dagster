# Grants user code deployment the permissions to pull images from Artifact Registry
resource "kubernetes_secret" "artifact_registry" {
  metadata {
    name = "artifact-registry"
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "https://${var.registry.id}-docker.pkg.dev" = {
          auth = "${base64encode("_json_key:${var.service_account_json}")}"
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "helm_release" "user_deployment" {
  name       = "dagster-code"
  version    = var.dagster_version
  repository = "https://dagster-io.github.io/helm"
  chart      = "dagster-user-deployments"
  # Current values can be found here https://artifacthub.io/packages/helm/dagster/dagster-user-deployments?modal=values
  values = [
    <<EOT
deployments:
  - name: "dagster-pipelines"
    image:
      repository: "${var.registry.location}-docker.pkg.dev/${var.registry.project}/${var.registry.repository_id}/${var.dagster_deployment_image}"
      tag: "${var.dagster_deployment_tag}"
      pullPolicy: Always
    dagsterApiGrpcArgs:
      - "-f"
      - "pipelines/repository.py"
    port: ${var.deployment_port}
    volumes: []
    volumeMounts: []
    env: {}
    envConfigMaps: []
    envSecrets: []

    annotations: {}
    nodeSelector: {}
    affinity: {}
    tolerations: []
    podSecurityContext: {}
    securityContext: {}
    resources: {}
    replicaCount: 1
    labels: {}
    livenessProbe:
      periodSeconds: 20
      timeoutSeconds: 3
      successThreshold: 1
      failureThreshold: 3

    startupProbe:
      enabled: true
      initialDelaySeconds: 0
      periodSeconds: 10
      timeoutSeconds: 3
      successThreshold: 1
      failureThreshold: 3

    service:
      annotations: {}

imagePullSecrets: [{"name": '${kubernetes_secret.artifact_registry.metadata[0].name}'}]
EOT
  ]

  depends_on = [kubernetes_secret.artifact_registry]
}

resource "helm_release" "dagster_service" {
  name       = "dagster-service"
  version    = var.dagster_version
  repository = "https://dagster-io.github.io/helm"
  chart      = "dagster"
  # Current values can be found here https://artifacthub.io/packages/helm/dagster/dagster?modal=values
  values = [
    <<EOT
dagit:
  workspace:
    enabled: true
    servers:
      - host: "dagster-pipelines"
        port: ${var.deployment_port}

dagster-user-deployments:
  enableSubchart: false

postgresql:
  enabled: false
  postgresqlHost: "${var.database_host}"
  postgresqlUsername: "${var.database_username}"
  postgresqlPassword: "${var.database_password}"
  postgresqlDatabase: "${var.database_name}"
EOT
  ]

  # Service must be able to connect to the user deployment before startup as it
  # is expecting the workspace to be made available over gRPC on the defined port
  # that's shared between the two releases.
  depends_on = [helm_release.user_deployment]
}
