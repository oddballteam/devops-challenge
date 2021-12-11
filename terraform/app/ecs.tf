# Define the application container
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

resource "aws_cloudwatch_log_group" "app" {
  name              = "/${var.namespace}/app"
  retention_in_days = 30
}

resource "aws_ecs_cluster" "default" {
  name = "${local.prefix}-ecs-cluster"
}

# Create the ECS service task definition
module "ecs_service" {
  source                    = "git::https://github.com/cloudposse/terraform-aws-ecs-alb-service-task.git?ref=tags/0.56.0"
  namespace                 = var.namespace
  name                      = var.name
  stage                     = var.stage
  vpc_id                    = data.aws_vpc.default.id
  ecs_cluster_arn           = aws_ecs_cluster.default.arn
  container_definition_json = module.app_container.json_map_encoded_list
  subnet_ids                = data.aws_subnet_ids.us-east.ids
  alb_security_group        = module.alb.security_group_id
  launch_type               = "FARGATE"
  desired_count             = 1
  assign_public_ip          = true
  ecs_load_balancers = [
    {
      container_name   = var.name
      container_port   = var.app_container_port
      elb_name         = null
      target_group_arn = module.alb.default_target_group_arn
    }
  ]
}
