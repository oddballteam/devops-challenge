resource "aws_ecs_cluster" "default" {
  name = local.prefix
  tags = module.cluster_label.tags
}

module "app_container" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.58.1"
  container_name               = var.name
  container_image              = var.container_image
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_cpu
  essential                    = false
  environment = [
    {
      name  = "SSM_PATH_PREFIX"
      value = local.ssm_path_prefix
    }
  ]
 port_mappings = [
    {
      containerPort = local.app_container_port
      hostPort      = local.app_container_port
      protocol      = "tcp"
    }
  ]
  log_configuration = {
    logDriver = var.log_driver
    options = {
      "awslogs-region"        = local.region
      "awslogs-group"         = aws_cloudwatch_log_group.app.name
      "awslogs-stream-prefix" = local.app_container_name
    }
    secretOptions = null

  }
}

module "nginx_container" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.58.1"
  container_name               = var.nginx-name
  container_image              = var.container_image_nginx
  container_memory             = var.container_nginx_memory
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_nginx_cpu
  container_depends_on = [
    {
      containerName = local.app_container_name
      condition     = "START"
    }
  ]
  port_mappings = [
    {
      containerPort = local.nginx_container_port
      hostPort      = local.nginx_container_port
      protocol      = "tcp"
    }
  ]
  log_configuration = {
    logDriver = var.log_driver
    options = {
      "awslogs-region"        = local.region
      "awslogs-group"         = aws_cloudwatch_log_group.nginx.name
      "awslogs-stream-prefix" = local.nginx_container_name
    }
    secretOptions = null
  }
}

