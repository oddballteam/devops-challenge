locals {
  listener_arns     = module.alb.listener_arns
  alb_arn_suffix    = module.alb.alb_arn_suffix
  alb_dns_name      = module.alb.alb_dns_name
  alb_zone_id       = module.alb.alb_zone_id
  security_group_id = module.alb.security_group_id
}

module "alb" {
  source                                  = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=0.35.3"
  vpc_id                                  = data.aws_vpc.default.id
  subnet_ids                              = data.aws_subnet_ids.us-east.ids
  load_balancer_name                      = "${local.prefix}-alb"
  attributes                              = [local.prefix]
  alb_access_logs_s3_bucket_force_destroy = true
}

#resource "aws_lb_listener_rule" "default" {
#  listener_arn = local.listener_arns[0]
#  action {
#    type             = "forward"
#    target_group_arn = module.alb.default_target_group_arn
#  }
#}
