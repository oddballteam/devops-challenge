module "nginx-ecr" {
  source               = "git::https://github.com/cloudposse/terraform-aws-ecr.git?ref=0.32.3"
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.nginx-name
  scan_images_on_push  = var.scan_images_on_push
  image_tag_mutability = "IMMUTABLE"
  image_names          = ["${var.namespace}-${var.nginx-name}-${var.stage}"]
  tags = {
    Terraform = "true"
    app       = var.namespace
  }
}

module "ecr" {
  source               = "git::https://github.com/cloudposse/terraform-aws-ecr.git?ref=0.32.3"
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  image_names          = ["${var.namespace}-${var.name}-${var.stage}"]
  image_tag_mutability = "IMMUTABLE"
  scan_images_on_push  = var.scan_images_on_push
  tags = {
    Terraform = "true"
    app       = var.namespace
  }
}
