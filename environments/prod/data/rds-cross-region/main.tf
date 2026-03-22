data "terraform_remote_state" "networking_ireland" {
  backend = "s3"

  config = {
    bucket = var.tfstate_bucket
    key    = var.networking_ireland_state_key
    region = var.tfstate_region
  }
}

data "terraform_remote_state" "networking_spain" {
  backend = "s3"

  config = {
    bucket = var.tfstate_bucket
    key    = var.networking_spain_state_key
    region = var.tfstate_region
  }
}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "aws-multi-region"
    Component   = "aurora-global"
  }

  primary_allowed_cidrs   = distinct(concat([data.terraform_remote_state.networking_ireland.outputs.vpc_cidr_block], var.allowed_cidr_blocks))
  secondary_allowed_cidrs = distinct(concat([data.terraform_remote_state.networking_spain.outputs.vpc_cidr_block], var.allowed_cidr_blocks))
}

resource "random_password" "aurora_master" {
  length  = 24
  special = false
}

resource "aws_rds_global_cluster" "this" {
  provider = aws.ireland

  global_cluster_identifier = var.global_cluster_identifier
  engine                    = var.engine
  engine_version            = var.engine_version
  database_name             = var.database_name
  storage_encrypted         = var.storage_encrypted
}

module "aurora_primary" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.16.0"

  providers = {
    aws = aws.ireland
  }

  name                      = "${var.cluster_name}-primary"
  engine                    = aws_rds_global_cluster.this.engine
  engine_version            = aws_rds_global_cluster.this.engine_version
  database_name             = aws_rds_global_cluster.this.database_name
  global_cluster_identifier = aws_rds_global_cluster.this.id

  instance_class = var.instance_class
  instances      = { for i in range(var.instance_count_primary) : i => {} }

  vpc_id                 = data.terraform_remote_state.networking_ireland.outputs.vpc_id
  create_db_subnet_group = true
  subnets                = data.terraform_remote_state.networking_ireland.outputs.private_subnet_ids

  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = local.primary_allowed_cidrs
    }
  }

  manage_master_user_password = false
  master_username             = var.master_username
  master_password             = random_password.aurora_master.result

  storage_encrypted   = var.storage_encrypted
  apply_immediately   = var.apply_immediately
  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  tags = merge(local.common_tags, { Role = "primary", Region = var.ireland_region })
}

module "aurora_secondary" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.16.0"

  providers = {
    aws = aws.spain
  }

  is_primary_cluster        = false
  name                      = "${var.cluster_name}-secondary"
  engine                    = aws_rds_global_cluster.this.engine
  engine_version            = aws_rds_global_cluster.this.engine_version
  global_cluster_identifier = aws_rds_global_cluster.this.id
  source_region             = var.ireland_region

  instance_class = var.instance_class
  instances      = { for i in range(var.instance_count_secondary) : i => {} }

  vpc_id                 = data.terraform_remote_state.networking_spain.outputs.vpc_id
  create_db_subnet_group = true
  subnets                = data.terraform_remote_state.networking_spain.outputs.private_subnet_ids

  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = local.secondary_allowed_cidrs
    }
  }

  manage_master_user_password = false
  master_password             = random_password.aurora_master.result

  storage_encrypted   = var.storage_encrypted
  apply_immediately   = var.apply_immediately
  deletion_protection = var.deletion_protection
  skip_final_snapshot = true

  depends_on = [module.aurora_primary]

  tags = merge(local.common_tags, { Role = "secondary", Region = var.spain_region })
}

module "private_dns_zone" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "5.0.0"

  providers = {
    aws = aws.ireland
  }

  zones = {
    (var.route53_private_zone_name) = {
      comment = "Private DNS zone for ${var.environment} Aurora Global Database"
      vpc = [
        {
          vpc_id     = data.terraform_remote_state.networking_ireland.outputs.vpc_id
          vpc_region = var.ireland_region
        },
        {
          vpc_id     = data.terraform_remote_state.networking_spain.outputs.vpc_id
          vpc_region = var.spain_region
        }
      ]
      tags = merge(local.common_tags, { Component = "route53-private-zone" })
    }
  }
}

module "aurora_dns_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "5.0.0"

  providers = {
    aws = aws.ireland
  }

  zone_id = module.private_dns_zone.route53_zone_zone_id[var.route53_private_zone_name]

  records = [
    {
      name    = var.route53_writer_record_name
      type    = "CNAME"
      ttl     = var.route53_record_ttl
      records = [module.aurora_primary.cluster_endpoint]
    },
    {
      name    = var.route53_reader_record_name
      type    = "CNAME"
      ttl     = var.route53_record_ttl
      records = [module.aurora_primary.cluster_reader_endpoint]
    }
  ]

  depends_on = [module.private_dns_zone]
}
