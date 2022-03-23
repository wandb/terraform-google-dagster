# Ensures APIs are all enabled in project
module "project_factory_project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.3"

  project_id = null

  activate_apis = [
    "iam.googleapis.com",               # Service accounts
    "logging.googleapis.com",           # Logging
    "sqladmin.googleapis.com",          # Database
    "networkmanagement.googleapis.com", # Networking
    "servicenetworking.googleapis.com", # Networking
    "storage.googleapis.com",           # Cloud Storage
    "artifactregistry.googleapis.com",  # Artifact Registry
    "container.googleapis.com",         # Kubernetes
    "compute.googleapis.com"            # Kubernetes
  ]
  disable_dependent_services  = false
  disable_services_on_destroy = false
}

# Required for Artifact Registry. Google provider does not have 
# support for this cloud resource.
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
  source                        = "./modules/storage"
  namespace                     = var.namespace
  deletion_protection           = var.deletion_protection
  cloud_storage_bucket_location = var.cloud_storage_bucket_location

  service_account = module.service_account.service_account

  depends_on = [module.service_account]
}

module "networking" {
  source    = "./modules/networking"
  namespace = var.namespace
}

module "cluster" {
  source                       = "./modules/cluster"
  namespace                    = var.namespace
  cluster_compute_machine_type = var.cluster_compute_machine_type
  cluster_node_count           = var.cluster_node_count

  network         = module.networking.network
  subnetwork      = module.networking.subnetwork
  service_account = module.service_account.service_account

  depends_on = [module.networking, module.service_account]
}

module "database" {
  source                     = "./modules/database"
  namespace                  = var.namespace
  deletion_protection        = var.deletion_protection
  cloudsql_postgres_version  = var.cloudsql_postgres_version
  cloudsql_tier              = var.cloudsql_tier
  cloudsql_availability_type = var.cloudsql_availability_type

  network_connection = module.networking.connection

  depends_on = [module.networking]
}

data "google_client_config" "current" {}

provider "kubernetes" {
  host                   = "https://${module.cluster.cluster_endpoint}"
  cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
}

module "registry" {
  source    = "./modules/registry"
  namespace = var.namespace
  location  = var.region

  service_account             = module.service_account.service_account
  service_account_credentials = module.service_account.service_account_credentials

  # Depends on cluster existing as Kubernetes secret will be created containing an imagePullSecret
  # with Docker config for private registry
  depends_on = [module.cluster, module.service_account]
}
