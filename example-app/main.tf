module "dagster_infra" {
  source               = "../"
  project_id           = var.project_id
  region               = var.region
  zone                 = var.zone
  namespace            = var.namespace
  compute_machine_type = var.compute_machine_type
  deletion_protection  = var.deletion_protection
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
  - name: "k8s-example-user-code-1"
    image:
      repository: "${module.dagster_infra.registry_image_path}/${var.dagster_deployment_image}"
      tag: "${var.dagster_deployment_tag}"
      pullPolicy: Always
    dagsterApiGrpcArgs:
      - "--python-file"
      - "/example_project/example_repo/repo.py"
    port: 3030
    volumes: []
    volumeMounts: []
    env: {}
    envConfigMaps: []
    envSecrets: []

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

imagePullSecrets:
  - name: "${module.dagster_infra.private_docker_config_secret}"
EOT
  ]

  depends_on = [module.dagster_infra]
}

resource "helm_release" "dagster_service" {
  name       = "dagster-service"
  version    = var.dagster_version
  repository = "https://dagster-io.github.io/helm"
  chart      = "dagster"
  # Current values can be found here https://artifacthub.io/packages/helm/dagster/dagster?modal=values
  values = [
    <<EOT
imagePullSecrets:
  - name: "${module.dagster_infra.private_docker_config_secret}"
dagit:
  workspace:
    enabled: true
    servers:
      - host: "dagster-pipelines"
        port: 3030

  # dagster-user-deployments:
  #   enableSubchart: false

postgresql:
  enabled: false
  postgresqlHost: "${module.dagster_infra.database.host}"
  postgresqlUsername: "${module.dagster_infra.database.username}"
  postgresqlDatabase: "${module.dagster_infra.database.name}"
EOT
  ]

  set_sensitive {
    name  = "postgresql.postgresqlPassword"
    value = module.dagster_infra.database.password
  }

  depends_on = [module.dagster_infra]
}
