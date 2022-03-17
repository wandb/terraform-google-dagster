locals {
  output_private_ip    = google_sql_database_instance.default.private_ip_address
  output_database_name = google_sql_database.default.name
  output_username      = google_sql_user.default.name
  output_password      = google_sql_user.default.password
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
