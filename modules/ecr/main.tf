# ECR Repository
resource "aws_ecr_repository" "ecr_repository" {
  name = "${var.environment}-${var.project_name}-ecr-repository"

  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.environment}-${var.project_name}-ecr-repository"
  }
}