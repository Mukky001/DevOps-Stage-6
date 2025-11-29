terraform {
  backend "s3" {
    # Update this bucket name!
    bucket = "devops-stage6-task"
    key    = "stage6/terraform.tfstate"
    region = "eu-north-1"
  }
}
