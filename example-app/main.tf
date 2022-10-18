terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.13"
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
  zone       = var.zone
  namespace  = var.namespace

  # cloud_storage_bucket_location (default US)
  # cloudsql_postgres_version (default POSTGRES_14)
  # cloudsql_tier (default db-f1-micro)
  # cloudsql_availability_type (default ZONAL)
  # cluster_compute_machine_type (default e2-standard-2)
  # cluster_node_pool_max_node_count (default 2)
  # deletion_protection (default true)
}

data "google_client_config" "current" {}

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
    dagit = {
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
