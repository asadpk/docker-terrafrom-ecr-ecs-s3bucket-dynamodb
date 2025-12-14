terraform {
  backend "s3" {
    bucket         = "tcb-devops-mod3-state-hsps"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "humangov-terraform-state-lock-table"
  }
}
