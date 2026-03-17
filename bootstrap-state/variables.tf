variable "aws_region" {
  description = "Region where S3 and DynamoDB will be created for the backend"
  type        = string
  default     = "eu-west-1"
}

variable "name_prefix" {
  description = "Prefix used to name remote state resources"
  type        = string
  default     = "aws-multi-region"
}
