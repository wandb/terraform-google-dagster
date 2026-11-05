mock_provider "google" {}
mock_provider "random" {}

variables {
  namespace                       = "dagster-test"
  network_connection              = { network = "projects/test-project/global/networks/test" }
  deletion_protection             = true
  cloudsql_postgres_version       = "POSTGRES_14"
  cloudsql_tier                   = "db-f1-micro"
  cloudsql_availability_type      = "ZONAL"
  cloudsql_edition                = "ENTERPRISE"
  cloudsql_query_insights_enabled = false
}

run "database_flags" {
  command = plan

  assert {
    condition = contains(google_sql_database_instance.default.settings[0].database_flags, {
      name = "cloudsql.enable_pgaudit", value = "on"
    })
    error_message = "Cloud SQL must enable pgAudit."
  }

  assert {
    condition = contains(google_sql_database_instance.default.settings[0].database_flags, {
      name = "pgaudit.log", value = "ddl,role"
    })
    error_message = "pgAudit must log DDL and role operations only."
  }

  assert {
    condition = contains(google_sql_database_instance.default.settings[0].database_flags, {
      name = "cloudsql.iam_authentication", value = "on"
    })
    error_message = "Cloud SQL must preserve IAM authentication."
  }

  assert {
    condition = contains(google_sql_database_instance.default.settings[0].database_flags, {
      name = "max_connections", value = "1000"
    })
    error_message = "Cloud SQL must preserve the max_connections setting."
  }
}
