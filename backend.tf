terraform {
    backend "s3" {
        bucket = "terraform-k8s459887"
        key    = "development/terraform_state"
        region = "us-east-1"
    }
}