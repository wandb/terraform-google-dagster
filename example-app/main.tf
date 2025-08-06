terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.9"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.4"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Much more is configurable here, this simply uses the defaults for cloud resources
module "dagster_infra" {
  source     = "../"
  project_id = var.project_id
  region     = var.region
  namespace  = var.namespace
  domain     = var.domain

  # Custom networking configuration
  enable_custom_networking = var.enable_custom_networking
  custom_networking        = var.custom_networking

  # cloud_storage_bucket_location (default US)
  # cloudsql_postgres_version (default POSTGRES_14)
  # cloudsql_tier (default db-f1-micro)
  # cloudsql_availability_type (default ZONAL)
  # cluster_compute_machine_type (default e2-standard-2)
  # cluster_node_pool_max_node_count (default 2)
  # deletion_protection (default true)
}

data "google_client_config" "current" {}

provider "kubernetes" {
  host                   = "https://${module.dagster_infra.cluster_endpoint}"
  cluster_ca_certificate = base64decode(module.dagster_infra.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.dagster_infra.cluster_endpoint}"
    cluster_ca_certificate = base64decode(module.dagster_infra.cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}

locals {
  code_deployment_name = "pipelines"
  code_deployment_port = 9090
  imagePullSecrets = [{ # tflint-ignore: terraform_naming_convention
    name = module.dagster_infra.registry_image_pull_secret
  }]
  user_deployment_values = {
    deployments = [
      {
        name = local.code_deployment_name
        image = {
          repository = "${module.dagster_infra.registry_image_path}/${var.dagster_deployment_image}"
          tag        = var.dagster_deployment_tag
          pullPolicy = "Always"
        }
        dagsterApiGrpcArgs = ["-f", "path/to/repository.py"]
        port               = local.code_deployment_port
      }
    ]
    imagePullSecrets = local.imagePullSecrets
  }
  service_values = {
    dagsterWebserver = {
      workspace = {
        enabled = true
        servers = [{
          host = local.code_deployment_name
          port = local.code_deployment_port
        }]
      }
    }
    dagster-user-deployments = {
      enableSubchart = false
    }
    postgresql = {
      # Disables postgresql service pod. This is non-persistent in that it will be destroyed when infrastructure
      # changes or the pod is restarted. It's intented for ephemeral or test usage.
      enabled            = false
      postgresqlHost     = module.dagster_infra.cloudsql_database.host
      postgresqlUsername = module.dagster_infra.cloudsql_database.username
      postgresqlDatabase = module.dagster_infra.cloudsql_database.name
      postgresqlPassword = module.dagster_infra.cloudsql_database.password
    }
    imagePullSecrets = local.imagePullSecrets
  }
}

# IMPORTANT:
# Before your helm release is deployed you must ensure you have your code deployment image is pushed to
# your private repository. This will not break anything other than put your pod into an imagePullBackoff
# state as it won't be able to find your Docker image.
resource "helm_release" "dagster_user_deployment" {
  name       = "dagster-code"
  version    = var.dagster_version
  repository = "https://dagster-io.github.io/helm"
  chart      = "dagster-user-deployments"
  # Current values can be found here https://artifacthub.io/packages/helm/dagster/dagster-user-deployments?modal=values
  values = [yamlencode(local.user_deployment_values)]

  depends_on = [module.dagster_infra]
}

resource "helm_release" "dagster_service" {
  name       = "dagster-service"
  version    = var.dagster_version
  repository = "https://dagster-io.github.io/helm"
  chart      = "dagster"
  # Current values can be found here https://artifacthub.io/packages/helm/dagster/dagster?modal=values
  values = [yamlencode(local.service_values)]

  depends_on = [module.dagster_infra]
}

# Optional IAP resources for zero-trust example
resource "google_compute_global_address" "dagster_ip" {
  count = var.enable_iap_example ? 1 : 0
  name  = "${var.namespace}-dagster-ip"
}

resource "google_iap_web_iam_binding" "dagster_iap_binding" {
  count = var.enable_iap_example && (length(var.iap_allowed_domains) > 0 || length(var.iap_allowed_users) > 0) ? 1 : 0

  members = concat(
    [for domain in var.iap_allowed_domains : "domain:${domain}"],
    [for user in var.iap_allowed_users : "user:${user}"]
  )
  role = "roles/iap.httpsResourceAccessor"
}

resource "kubernetes_secret" "iap_oauth_secret" {
  count = var.enable_iap_example ? 1 : 0

  metadata {
    name      = "${var.namespace}-iap-oauth-secret"
    namespace = "default"
  }

  data = {
    client_id     = var.oauth_client_id
    client_secret = var.oauth_client_secret
  }

  type = "Opaque"
}

resource "kubernetes_manifest" "dagster_backend_config" {
  count = var.enable_iap_example ? 1 : 0
  manifest = {
    apiVersion = "cloud.google.com/v1"
    kind       = "BackendConfig"
    metadata = {
      name      = "${var.namespace}-dagster-backend-config"
      namespace = "default"
    }
    spec = {
      iap = {
        enabled = true
        oauthclientCredentials = {
          secretName = kubernetes_secret.iap_oauth_secret[0].metadata[0].name
        }
      }
      healthCheck = {
        checkIntervalSec   = 10
        timeoutSec         = 5
        healthyThreshold   = 1
        unhealthyThreshold = 3
        type               = "HTTP"
        requestPath        = "/server_info"
        port               = 3000
      }
    }
  }
}

resource "google_compute_managed_ssl_certificate" "dagster_ssl_cert" {
  count = var.enable_iap_example ? 1 : 0
  name  = "${var.namespace}-dagster-ssl-cert"

  managed {
    domains = [var.domain]
  }
}

resource "kubernetes_ingress_v1" "dagster_ingress" {
  count = var.enable_iap_example ? 1 : 0

  metadata {
    name      = "${var.namespace}-dagster-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.dagster_ip[0].name
      "networking.gke.io/managed-certificates"      = google_compute_managed_ssl_certificate.dagster_ssl_cert[0].name
      "kubernetes.io/ingress.class"                 = "gce"
      "cloud.google.com/backend-config"             = "{\"default\":\"${kubernetes_manifest.dagster_backend_config[0].manifest.metadata.name}\"}"
    }
  }

  spec {
    rule {
      host = var.domain
      http {
        path {
          path      = "/*"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "dagster-service-dagster-webserver"
              port {
                number = 3000
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_manifest.dagster_backend_config,
    google_compute_managed_ssl_certificate.dagster_ssl_cert,
    helm_release.dagster_service
  ]
}
