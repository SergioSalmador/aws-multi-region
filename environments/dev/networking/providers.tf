terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  alias  = "ireland"
  region = var.ireland_region
}

provider "aws" {
  alias  = "spain"
  region = var.spain_region
}
