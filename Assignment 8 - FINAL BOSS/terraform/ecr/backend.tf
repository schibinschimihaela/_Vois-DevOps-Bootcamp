terraform {
  backend "s3" {
    bucket         = "ip-spectre-tf-state"
    key            = "ecr/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}