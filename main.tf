# Ensures APIs are all enabled in project
module "project_factory_project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.3"

  project_id = null

  activate_apis = [
    "iam.googleapis.com",               // Service accounts
    "logging.googleapis.com",           // Logging
    "sqladmin.googleapis.com",          // Database
    "networkmanagement.googleapis.com", // Networking
    "servicenetworking.googleapis.com", // Networking
    "storage.googleapis.com",           // Cloud Storage
    "artifactregistry.googleapis.com",  // Artifact Registry
    "container.googleapis.com",         // Kubernetes
    "compute.googleapis.com"            // Kubernetes
  ]
  disable_dependent_services  = false
  disable_services_on_destroy = false
}

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }

    google = {
      source  = "hashicorp/google"
      version = "4.13.0"
    }
  }
}

# Required for Artifact Registry. Base google provider does not have support for this
# cloud resource.
provider "google-beta" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "service_account" {
  source    = "./modules/service_account"
  namespace = var.namespace
}

module "storage" {
  source              = "./modules/storage"
  namespace           = var.namespace
  deletion_protection = var.deletion_protection

  bucket_location = "US"
  service_account = module.service_account.sa
}

module "networking" {
  source = "./modules/networking"

  namespace = var.namespace
}

module "cluster" {
  source               = "./modules/cluster"
  namespace            = var.namespace
  compute_machine_type = var.compute_machine_type

  network         = module.networking.network
  subnetwork      = module.networking.subnetwork
  service_account = module.service_account.sa
}

module "database" {
  source              = "./modules/database"
  namespace           = var.namespace
  deletion_protection = var.deletion_protection

  network_connection = module.networking.connection
}

module "registry" {
  source    = "./modules/registry"
  namespace = var.namespace
  location  = var.region

  service_account = module.service_account.sa
}

data "google_client_config" "current" {}

# Needed separately to provision Kubernetes objects natively
provider "kubernetes" {
  host                   = "https://${module.cluster.cluster_endpoint}"
  cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.cluster.cluster_endpoint}"
    cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
    token                  = data.google_client_config.current.access_token
  }
}

module "dagster" {
  source                   = "./modules/application"
  dagster_deployment_image = var.dagster_deployment_image
  dagster_deployment_tag   = var.dagster_deployment_tag

  registry             = module.registry.registry
  service_account_json = module.service_account.credentials
  database_host        = module.database.private_ip_address
  database_name        = module.database.database_name
  database_password    = module.database.password
  database_username    = module.database.username

  depends_on = [module.cluster, module.registry, module.database, module.service_account]
}
