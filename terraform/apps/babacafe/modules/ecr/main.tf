resource "aws_ecr_repository" "babacafe" {
  name = "${var.name_prefix}-ecr-repo"
}
