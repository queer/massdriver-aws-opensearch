resource "aws_security_group" "main" {
  vpc_id      = local.vpc_id
  name_prefix = "${var.md_metadata.name_prefix}-"
  description = "Control traffic to/from Opensearch: ${var.md_metadata.name_prefix}"

  lifecycle {
    create_before_destroy = true
  }
}

# TODO: enable security groups once bundle spec is updated to emit in artifact.
# resource "aws_security_group_rule" "ingress_security_groups" {
# }

# Note: this rule here is to support ingress from the VPC until we add in security group support for applications in AWS
resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = 1
  description       = "From allowed CIDRs"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = [var.network.data.infrastructure.cidr]
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "egress" {
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}
