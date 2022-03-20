locals {
  output_private_ip    = google_sql_database_instance.default.private_ip_address
  output_database_name = google_sql_database.default.name
  output_username      = google_sql_user.default.name
  output_password      = google_sql_user.default.password
}

output "database" {
  value = {
    host     = local.output_private_ip
    name     = local.output_database_name
    username = local.output_username
    password = local.output_password
  }
  description = "Database connection parameters"
}

output "private_ip_address" {
  value       = local.output_private_ip
  description = "The private IP address of the SQL database instance."
}

output "database_name" {
  value = local.output_database_name
}

output "username" {
  value = local.output_username
}

output "password" {
  value = local.output_password
}
