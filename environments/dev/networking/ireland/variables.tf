variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "region_name" {
  description = "Short region label used in resource names"
  type        = string
  default     = "ireland"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to use"
  type        = number
  default     = 3
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway"
  type        = bool
  default     = false
}

variable "enable_client_vpn" {
  description = "Enable Client VPN endpoint"
  type        = bool
  default     = true
}

variable "client_vpn_organization_name" {
  description = "Organization name used for Client VPN certificates"
  type        = string
  default     = "aws-multi-region-dev"
}

variable "client_vpn_logging_enabled" {
  description = "Enable CloudWatch logging for Client VPN"
  type        = bool
  default     = true
}

variable "client_vpn_client_cidr" {
  description = "Client CIDR block for the Client VPN endpoint"
  type        = string
  default     = "172.16.0.0/22"
}
