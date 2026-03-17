variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "ireland_region" {
  description = "Ireland AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "spain_region" {
  description = "Spain AWS region"
  type        = string
  default     = "eu-south-2"
}

variable "ireland_cidr" {
  description = "CIDR block for the Ireland VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "spain_cidr" {
  description = "CIDR block for the Spain VPC"
  type        = string
  default     = "10.21.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to use per VPC"
  type        = number
  default     = 3
}

variable "ireland_public_subnets" {
  description = "CIDR blocks for public subnets in Ireland"
  type        = list(string)
  default     = ["10.20.0.0/24", "10.20.1.0/24", "10.20.2.0/24"]
}

variable "ireland_private_subnets" {
  description = "CIDR blocks for private subnets in Ireland"
  type        = list(string)
  default     = ["10.20.10.0/24", "10.20.11.0/24", "10.20.12.0/24"]
}

variable "spain_public_subnets" {
  description = "CIDR blocks for public subnets in Spain"
  type        = list(string)
  default     = ["10.21.0.0/24", "10.21.1.0/24", "10.21.2.0/24"]
}

variable "spain_private_subnets" {
  description = "CIDR blocks for private subnets in Spain"
  type        = list(string)
  default     = ["10.21.10.0/24", "10.21.11.0/24", "10.21.12.0/24"]
}
