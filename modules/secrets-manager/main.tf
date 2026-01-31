# Data source to fetch the secret
data "aws_secretsmanager_secret" "secrets" {
  name = var.secret_name
}

# Data source to get the secret value
data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

# Parse the JSON secret string
locals {
  secrets = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)
}


