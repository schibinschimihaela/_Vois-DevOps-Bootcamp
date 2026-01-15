terraform {
  backend "s3" {
    bucket         = "ip-spectre-tf-state"
    key            = "infra/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
