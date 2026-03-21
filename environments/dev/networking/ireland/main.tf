data "aws_availability_zones" "this" {
  state = "available"
}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "aws-multi-region"
  }

  vpn_authorization_rules = [
    {
      name                 = "allow-vpc"
      description          = "Allow access to private services in the VPC"
      target_network_cidr  = var.vpc_cidr
      authorize_all_groups = true
    }
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = "${var.environment}-${var.region_name}-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.this.names, 0, var.az_count)
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = false

  tags = merge(local.common_tags, { Region = var.aws_region })
}

module "ec2_client_vpn" {
  count   = var.enable_client_vpn ? 1 : 0
  source  = "cloudposse/ec2-client-vpn/aws"
  version = "2.0.0"

  name                = "${var.environment}-${var.region_name}-client-vpn"
  organization_name   = var.client_vpn_organization_name
  associated_subnets  = module.vpc.private_subnets
  vpc_id              = module.vpc.vpc_id
  client_cidr         = var.client_vpn_client_cidr
  authorization_rules = local.vpn_authorization_rules

  logging_enabled     = var.client_vpn_logging_enabled
  logging_stream_name = "${var.environment}-${var.region_name}-client-vpn"
  split_tunnel        = true
}
