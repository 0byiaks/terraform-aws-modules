#!/bin/bash
set -e  # Exit on any error
set -x  # Print commands as they execute

# Log file for troubleshooting
LOG_FILE="/var/log/migration-script.log"
exec > >(tee -a $LOG_FILE) 2>&1

echo "=========================================="
echo "Migration script started at $(date)"
echo "=========================================="

# Install jq if not available (for JSON parsing)
echo "Installing jq..."
sudo yum install -y jq || { echo "Failed to install jq"; exit 1; }

# Retrieve secret from Secrets Manager
echo "Retrieving secret from Secrets Manager..."
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id ${SECRET_NAME} \
  --region ${AWS_REGION} \
  --query SecretString \
  --output text) || { echo "Failed to retrieve secret"; exit 1; }

# Parse username and password from JSON
export RDS_DB_PASSWORD=$(echo $SECRET_JSON | jq -r '.password') || { echo "Failed to parse secret"; exit 1; }

if [ -z "$RDS_DB_PASSWORD" ]; then
  echo "ERROR: RDS_DB_PASSWORD is empty"
  exit 1
fi

# ================================================================
# Install Flyway and run database migrations
# ================================================================

echo "Updating packages..."
sudo yum update -y || { echo "Failed to update packages"; exit 1; }

# Navigate to a consistent directory
cd /home/ec2-user || { echo "Failed to change directory"; exit 1; }

echo "Downloading Flyway ${FLYWAY_VERSION}..."
sudo wget -qO- https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz | tar -xvz || { echo "Failed to download/extract Flyway"; exit 1; }

FLYWAY_DIR="/home/ec2-user/flyway-${FLYWAY_VERSION}"
if [ ! -d "$FLYWAY_DIR" ]; then
  echo "ERROR: Flyway directory not found: $FLYWAY_DIR"
  exit 1
fi

echo "Creating symlink for Flyway..."
sudo ln -sf $FLYWAY_DIR/flyway /usr/local/bin/flyway || { echo "Failed to create symlink"; exit 1; }

# Verify flyway is accessible
if ! command -v flyway &> /dev/null; then
  echo "ERROR: flyway command not found in PATH"
  exit 1
fi

# Create the SQL directory for migrations
echo "Creating SQL directory..."
sudo mkdir -p sql || { echo "Failed to create sql directory"; exit 1; }

# Download the migration SQL script from AWS S3
echo "Downloading migration files from S3: ${S3_URI}"
sudo aws s3 cp ${S3_URI} sql/ || { echo "Failed to download from S3"; exit 1; }

# List downloaded files
echo "Files in sql directory:"
ls -la sql/

# Run Flyway migration
echo "Running Flyway migration..."
echo "Connecting to: jdbc:mysql://${RDS_ENDPOINT}:3306/${RDS_DB_NAME}"
sudo flyway -url=jdbc:mysql://${RDS_ENDPOINT}:3306/${RDS_DB_NAME}?allowPublicKeyRetrieval=true \
  -user=${RDS_DB_USERNAME} \
  -password="$${RDS_DB_PASSWORD}" \
  -locations=filesystem:sql \
  migrate || { echo "Flyway migration failed"; exit 1; }

echo "=========================================="
echo "Migration completed successfully at $(date)"
echo "=========================================="

# Terminate the instance after waiting 7 minutes
echo "Scheduling instance shutdown in 7 minutes..."
sudo shutdown -h +7