# Ensures APIs are all enabled in project
module "project_factory_project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 18.0"

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

module "service_account" {
  source     = "./modules/service_account"
  project_id = var.project_id
  namespace  = var.namespace
}

module "storage" {
  source                        = "./modules/storage"
  namespace                     = var.namespace
  deletion_protection           = var.deletion_protection
  cloud_storage_bucket_location = var.cloud_storage_bucket_location

  service_account = module.service_account.service_account

  depends_on = [module.service_account]
}

locals {
  use_custom_networking = var.custom_networking.network_self_link != null && var.custom_networking.subnetwork_self_link != null

  enable_private_cluster = coalesce(
    var.custom_networking.enable_private_cluster,
    false
  )

  master_ipv4_cidr_block = var.custom_networking.master_ipv4_cidr_block

  authorized_networks = length(var.custom_networking.authorized_networks) > 0 ? var.custom_networking.authorized_networks : []
}

# Create networking only if not using custom networking
module "networking" {
  count = local.use_custom_networking ? 0 : 1

  source    = "./modules/networking"
  namespace = var.namespace
  project   = var.project_id
  region    = var.region
}

module "custom_networking" {
  count = local.use_custom_networking ? 1 : 0

  source     = "./modules/custom-networking"
  namespace  = var.namespace
  project_id = var.project_id
  region     = var.region

  network_self_link    = var.custom_networking.network_self_link
  subnetwork_self_link = var.custom_networking.subnetwork_self_link
}

module "cluster" {
  source                           = "./modules/cluster"
  namespace                        = var.namespace
  project_id                       = var.project_id
  cluster_compute_machine_type     = var.cluster_compute_machine_type
  cluster_node_pool_max_node_count = var.cluster_node_pool_max_node_count
  domain                           = var.domain
  cluster_monitoring_components    = var.cluster_monitoring_components

  network    = coalesce(try(module.custom_networking[0].network, null), module.networking[0].network)
  subnetwork = coalesce(try(module.custom_networking[0].subnetwork, null), module.networking[0].subnetwork)

  enable_private_cluster = local.enable_private_cluster
  master_ipv4_cidr_block = local.master_ipv4_cidr_block
  authorized_networks    = local.authorized_networks

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

  network_connection = coalesce(
    try(module.custom_networking[0].connection, null),
    module.networking[0].connection
  )

  depends_on = [module.networking, module.custom_networking]
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
