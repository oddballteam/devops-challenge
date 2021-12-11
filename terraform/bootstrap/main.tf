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
  region = var.region
}


module "ecr" {
  source               = "git::https://github.com/cloudposse/terraform-aws-ecr.git?ref=0.32.3"
  image_names          = ["${var.namespace}-${var.name}"]
  image_tag_mutability = "IMMUTABLE"
  scan_images_on_push  = var.scan_images_on_push
  tags = {
    Terraform = "true"
    app       = var.namespace
  }
}
