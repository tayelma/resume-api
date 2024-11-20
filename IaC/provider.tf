#Terraform provider
terraform {
  required_version = ">= 1.9.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60.0"
    }
  }
  backend "s3" {
    profile = "Hilary"
    bucket = "states-tf-projects"
    key = "cloud-resume-api/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform"
  }

}

#AWS provider

provider "aws" {
  profile = "Hilary"
  region = var.region
}
