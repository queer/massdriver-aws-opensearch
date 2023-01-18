resource "random_string" "domain_name_first" {
  length  = 1
  lower   = true
  special = false
  number  = false
  upper   = false
}

resource "random_string" "domain_name" {
  length           = 27
  lower            = true
  number           = true
  special          = true
  override_special = "-"
  upper            = false
}

resource "random_password" "master_user_password" {
  length      = 16
  lower       = true
  number      = true
  special     = true
  upper       = true
  min_lower   = 1
  min_upper   = 1
  min_special = 1
  min_numeric = 1
}

locals {
  domain_name = "${random_string.domain_name_first.result}${random_string.domain_name.result}"
}

resource "aws_opensearch_domain" "main" {
  depends_on     = [aws_cloudwatch_log_resource_policy.opensearch_log_publishing_policy]
  domain_name    = local.domain_name
  engine_version = var.opensearch.version

  cluster_config {
    instance_type  = var.cluster.instance_type
    instance_count = var.cluster.instance_count
    # zone_awareness_enabled = true
    # zone_awareness_config = {
    #   availability_zone_count = 2 # or 3
    # }
  }

  encrypt_at_rest {
    enabled = true
    # TODO: custom KMS in pre-step, skip on
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  vpc_options {
    security_group_ids = [aws_security_group.main.id]
    subnet_ids         = slice(local.subnet_ids[var.networking.subnet_type], 0, local.num_azs)
  }

  dynamic "log_publishing_options" {
    for_each = var.logging
    content {
      enabled                  = true
      log_type                 = upper(log_publishing_options.key)
      cloudwatch_log_group_arn = aws_cloudwatch_log_group.main[log_publishing_options.key].arn
    }
  }

  advanced_security_options {
    # One form of auth must be configured below for audit logs
    enabled = true

    # TODO: TEMPORARY TO GET PAST AUDIT LOGS (need to make this conditional based on authN reqs)
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = "masteruser"
      master_user_password = random_password.master_user_password.result
    }
  }

  # ebs_options {
  #   ebs_enabled = true
  #   # iops - (Optional) Baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the GP3 and Provisioned IOPS EBS volume types.
  #   # throughput - (Required if volume_type is set to gp3) Specifies the throughput (in MiB/s) of the EBS volumes attached to data nodes. Applicable only for the gp3 volume type. Valid values are between 125 and 1000.
  #   # volume_size - (Required if ebs_enabled is set to true.) Size of EBS volumes attached to data nodes (in GiB).
  #   # volume_type - (Optional) Type of EBS volumes attached to data nodes.
  # }
}
