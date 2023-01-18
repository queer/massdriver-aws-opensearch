locals {
  vpc_id = element(split("/", var.network.data.infrastructure.arn), 1)
  subnet_ids = {
    "internal" = [for subnet in var.network.data.infrastructure.internal_subnets : element(split("/", subnet["arn"]), 1)]
    "private"  = [for subnet in var.network.data.infrastructure.private_subnets : element(split("/", subnet["arn"]), 1)]
  }

  # TODO: THIS will need to be calculated based on zone awareness
  num_azs = 1
}
