locals {
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnet_ids.us-east.ids
}

data "aws_vpc" "default" {
  filter {
    name   = "is-default"
    values = [true]
  }
}

data "aws_subnet_ids" "us-east" {
  vpc_id = local.vpc_id
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b"]
  }
}
