resource "aws_instance" "data-migrate-instance" {
  ami           = var.amazon_linux_2_ami_id
  instance_type = var.instance_type
  subnet_id = var.private_app_subnet_ids[0]
  vpc_security_group_ids = [var.dms_security_group_id]
  iam_instance_profile = var.ec2_role_name

  user_data_base64 = base64encode(templatefile("${path.module}/db-migrate-script.sh", {
    FLYWAY_VERSION  = "11.15.0"
    RDS_ENDPOINT    = var.db_endpoint
    RDS_DB_NAME     = var.rds_db_name
    RDS_DB_USERNAME = var.rds_db_username
    
    S3_URI          = var.s3_uri
    AWS_REGION      = var.aws_region
    SECRET_NAME     = var.secret_name
  }))










  tags = {
    Name = "${var.environment}-${var.project_name}-data-migrate-instance"
  }
}