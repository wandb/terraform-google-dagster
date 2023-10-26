terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.30"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}

resource "random_string" "master_password" {
  length  = 32
  special = false
}

locals {
  database_name   = var.namespace
  master_username = var.namespace
  master_password = random_string.master_password.result
}

resource "google_sql_database_instance" "default" {
  database_version    = var.cloudsql_postgres_version
  name                = local.database_name
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.cloudsql_tier
    activation_policy = "ALWAYS"
    availability_type = var.cloudsql_availability_type

    ip_configuration {
      # We're giving the Cloud SQL instance a public IP address in order to connect to it with
      # Cloud SQL Proxy (which requires IAM authentication). We're not exposing the instance
      # to the internet because no external network is authorized.
      ipv4_enabled    = true
      private_network = var.network_connection.network
    }

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }

    backup_configuration {
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }

      enabled                        = true
      location                       = "us"
      start_time                     = "01:00"
      transaction_log_retention_days = 7
    }

    disk_autoresize       = true
    disk_autoresize_limit = 0
    disk_size             = 100
    disk_type             = "PD_SSD"

  }
}

resource "google_sql_database" "default" {
  name     = local.database_name
  instance = google_sql_database_instance.default.name

  depends_on = [google_sql_database_instance.default]
}

resource "google_sql_user" "default" {
  instance = google_sql_database_instance.default.name
  name     = local.master_username
  password = local.master_password

  depends_on = [google_sql_database_instance.default]
}
