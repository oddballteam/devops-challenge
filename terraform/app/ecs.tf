module "app_container" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.58.1"
  container_name               = var.name
  container_image              = var.container_image
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_cpu
  essential                    = true
  port_mappings = [
    {
      containerPort = var.app_container_port
      hostPort      = var.app_container_port
      protocol      = "tcp"
    }
  ]
  log_configuration = {
    logDriver = var.log_driver
    options = {
      "awslogs-region"        = var.region
      "awslogs-group"         = aws_cloudwatch_log_group.app.name
      "awslogs-stream-prefix" = var.name
    }
    secretOptions = null

  }
}

#module "nginx_container" {
#  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.58.1"
#  container_name               = var.nginx-name
#  container_image              = var.container_image_nginx
#  container_memory             = var.container_memory
#  container_memory_reservation = var.container_memory_reservation
#  container_cpu                = var.container_cpu
#  container_depends_on = [
#    {
#      containerName = var.name
#      condition     = "START"
#    }
#  ]
#  port_mappings = [
#    {
#      containerPort = var.nginx_container_port
#      hostPort      = var.nginx_container_port
#      protocol      = "tcp"
#    }
#  ]
#  log_configuration = {
#    logDriver = var.log_driver
#    options = {
#      "awslogs-region"        = var.region
#      "awslogs-group"         = aws_cloudwatch_log_group.nginx.name
#      "awslogs-stream-prefix" = var.nginx-name
#    }
#    secretOptions = null
#  }
#}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/${var.namespace}/app"
  retention_in_days = 30
}

#resource "aws_cloudwatch_log_group" "nginx" {
#  name = "/${var.namespace}/nginx"
#  retention_in_days = 30
#}

resource "aws_ecs_cluster" "default" {
  name = "${local.prefix}-ecs-cluster"
}

module "ecs_service" {
  source                    = "git::https://github.com/cloudposse/terraform-aws-ecs-alb-service-task.git?ref=tags/0.56.0"
  namespace                 = var.namespace
  name                      = var.name
  stage                     = var.stage
  vpc_id                    = local.vpc_id
  ecs_cluster_arn           = aws_ecs_cluster.default.arn
  container_definition_json = module.app_container.json_map_encoded_list
  subnet_ids                = local.subnet_ids
  alb_security_group        = local.security_group_id
  launch_type               = "FARGATE"
  assign_public_ip          = true
  ecs_load_balancers = [
    {
      container_name   = var.name
      container_port   = var.app_container_port
      elb_name         = null
      target_group_arn = local.target_group
    }
  ]
}
