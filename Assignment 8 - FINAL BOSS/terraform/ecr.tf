resource "aws_ecr_repository" "ip_spectre" {
  name = "ip-spectre"
  image_scanning_configuration {
    scan_on_push = true
  }
}
