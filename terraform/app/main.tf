terraform {
  required_version = "~> 0.13"

  #backend "s3" { # just use local state?
  #  bucket         = ""
  #  key            = "helloworld-app/bootstrap/dev/terraform.tfstate"
  #  dynamodb_table = ""
  #  region         = "us-east-1"
  #  encrypt        = "true"
  #}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

locals {
  prefix            = "${var.namespace}-${var.name}-${var.stage}"
}
