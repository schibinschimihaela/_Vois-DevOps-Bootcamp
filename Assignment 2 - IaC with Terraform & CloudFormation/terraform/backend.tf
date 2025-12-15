terraform {
  backend "s3" {
    bucket         = "mihaela-terraform-state-episode2"
    key            = "episode2/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
