resource "aws_ecr_repository" "pokeapp" {
  name = "${var.name_prefix}-ecr-repo"
}
