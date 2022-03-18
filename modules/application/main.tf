resource "helm_release" "user_deployment" {
  name       = "dagster-code"
  version    = var.dagster_version
  repository = "https://dagster-io.github.io/helm"
  chart      = "dagster-user-deployments"
  # Current values can be found here https://artifacthub.io/packages/helm/dagster/dagster-user-deployments?modal=values

  values = var.user_code_chart_path != null ? [var.user_code_chart_path] : null
  #     <<EOT
  # deployments:
  #   - name: "dagster-pipelines"
  #     image:
  #       repository: "${var.registry.location}-docker.pkg.dev/${var.registry.project}/${var.registry.repository_id}/${var.dagster_deployment_image}"
  #       tag: "${var.dagster_deployment_tag}"
  #       pullPolicy: Always
  #     dagsterApiGrpcArgs:
  #       - "-f"
  #       - "pipelines/repository.py"
  #     port: ${var.deployment_port}
  #     volumes: []
  #     volumeMounts: []
  #     env: {}
  #     envConfigMaps: []
  #     envSecrets: []

  #     annotations: {}
  #     nodeSelector: {}
  #     affinity: {}
  #     tolerations: []
  #     podSecurityContext: {}
  #     securityContext: {}
  #     resources: {}
  #     replicaCount: 1
  #     labels: {}
  #     livenessProbe:
  #       periodSeconds: 20
  #       timeoutSeconds: 3
  #       successThreshold: 1
  #       failureThreshold: 3

  #     startupProbe:
  #       enabled: true
  #       initialDelaySeconds: 0
  #       periodSeconds: 10
  #       timeoutSeconds: 3
  #       successThreshold: 1
  #       failureThreshold: 3

  #     service:
  #       annotations: {}

  # imagePullSecrets: [{"name": '${kubernetes_secret.artifact_registry.metadata[0].name}'}]
  # EOT
  #   ]
}

resource "helm_release" "dagster_service" {
  name       = "dagster-service"
  version    = var.dagster_version
  repository = "https://dagster-io.github.io/helm"
  chart      = "dagster"
  # Current values can be found here https://artifacthub.io/packages/helm/dagster/dagster?modal=values
  values = var.service_chart_path != null ? [var.service_chart_path] : null
  #   values = [
  #     <<EOT
  # dagit:
  #   workspace:
  #     enabled: true
  #     servers:
  #       - host: "dagster-pipelines"
  #         port: ${var.deployment_port}

  # dagster-user-deployments:
  #   enableSubchart: false

  # postgresql:
  #   enabled: false
  #   postgresqlHost: "${var.database_host}"
  #   postgresqlUsername: "${var.database_username}"
  #   postgresqlDatabase: "${var.database_name}"
  # EOT
  #   ]

  # set_sensitive {
  #   name  = "postgresql.postgresqlPassword"
  #   value = var.database_password
  # }
}
