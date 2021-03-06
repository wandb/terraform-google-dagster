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
      ipv4_enabled    = false
      private_network = var.network_connection.network
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
