data "aws_availability_zones" "ireland" {
  provider = aws.ireland
  state    = "available"
}

data "aws_availability_zones" "spain" {
  provider = aws.spain
  state    = "available"
}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "aws-multi-region"
  }
}

module "vpc_ireland" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  providers = {
    aws = aws.ireland
  }

  name = "${var.environment}-ireland-vpc"
  cidr = var.ireland_cidr

  azs             = slice(data.aws_availability_zones.ireland.names, 0, var.az_count)
  public_subnets  = var.ireland_public_subnets
  private_subnets = var.ireland_private_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = merge(local.common_tags, { Region = var.ireland_region })
}

module "vpc_spain" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  providers = {
    aws = aws.spain
  }

  name = "${var.environment}-spain-vpc"
  cidr = var.spain_cidr

  azs             = slice(data.aws_availability_zones.spain.names, 0, var.az_count)
  public_subnets  = var.spain_public_subnets
  private_subnets = var.spain_private_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = merge(local.common_tags, { Region = var.spain_region })
}
