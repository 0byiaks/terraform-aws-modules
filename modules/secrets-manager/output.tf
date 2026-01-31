# Output the entire parsed secrets as a map
output "secrets" {
  description = "All secrets parsed from JSON"
  value       = local.secrets
  sensitive   = true
}

# Output the raw secret string (JSON)
output "secrets_json" {
  description = "Raw JSON string from Secrets Manager"
  value       = data.aws_secretsmanager_secret_version.secrets.secret_string
  sensitive   = true
}

# Output individual secret values (you can add more as needed)
# Example: if your secret has keys like "username", "password", "database_url", etc.
# Uncomment and modify based on your actual secret keys

 output "username" {
  description = "Username from secrets"
   value       = local.secrets["username"]
  sensitive   = true
 }

output "password" {
  description = "Password from secrets"
   value       = local.secrets["password"]
   sensitive   = true
 }


output "db_name" {
  description = "Database name from secrets"
  value       = local.secrets["dbname"]
  sensitive   = true
}
