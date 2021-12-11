module "alb" {
  source                                  = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=0.35.3"
  vpc_id                                  = data.aws_vpc.default.id
  subnet_ids                              = data.aws_subnet_ids.us-east.ids
  load_balancer_name                      = "${local.prefix}-alb"
  attributes                              = [local.prefix]
  alb_access_logs_s3_bucket_force_destroy = true
}

