# Create IAM for EC2 with S3 access
resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}-${var.project_name}-s3-secret-manager-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Extract bucket name from S3 URI (format: s3://bucket-name/path or s3://bucket-name)
locals {
  s3_uri_cleaned = replace(var.s3_uri, "s3://", "")
  s3_bucket_name = split("/", local.s3_uri_cleaned)[0]
}

# Custom IAM policy for S3 and Secrets Manager with minimal permissions
resource "aws_iam_role_policy" "ec2_s3_secrets_policy" {
  name = "${var.environment}-${var.project_name}-s3-secrets-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${local.s3_bucket_name}",
          "arn:aws:s3:::${local.s3_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:${var.secret_name}*"
      }
    ]
  })
}

# Instance profile for EC2 to assume the role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.environment}-${var.project_name}-instance-profile-s3-secrets-access"
  role = aws_iam_role.ec2_role.name
}