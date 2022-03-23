output "cloudsql_database" {
  value = {
    host     = google_sql_database_instance.default.private_ip_address
    name     = google_sql_database.default.name
    username = google_sql_user.default.name
    password = google_sql_user.default.password
  }
  description = "Database connection parameters"
}
