variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "region_name" {
  description = "Short region label used in resource names"
  type        = string
  default     = "spain"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-south-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.21.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to use"
  type        = number
  default     = 3
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.21.0.0/24", "10.21.1.0/24", "10.21.2.0/24"]
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.21.10.0/24", "10.21.11.0/24", "10.21.12.0/24"]
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
  default     = "aws-multi-region-prod"
}

variable "client_vpn_logging_enabled" {
  description = "Enable CloudWatch logging for Client VPN"
  type        = bool
  default     = true
}

variable "client_vpn_client_cidr" {
  description = "Client CIDR block for the Client VPN endpoint"
  type        = string
  default     = "172.17.4.0/22"
}
