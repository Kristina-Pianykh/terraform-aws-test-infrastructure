resource "aws_ecr_repository" "app_ecr_repo" {
  name                 = "db_data_import"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}
