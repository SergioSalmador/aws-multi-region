variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "ireland_region" {
  description = "Primary AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "spain_region" {
  description = "Secondary AWS region"
  type        = string
  default     = "eu-south-2"
}

variable "tfstate_bucket" {
  description = "S3 bucket name used for remote state"
  type        = string
  default     = "REPLACE_WITH_BOOTSTRAP_BUCKET"
}

variable "tfstate_region" {
  description = "AWS region where tfstate bucket exists"
  type        = string
  default     = "eu-west-1"
}

variable "networking_ireland_state_key" {
  description = "Remote state key for Ireland networking stack"
  type        = string
  default     = "dev/networking/ireland/terraform.tfstate"
}

variable "networking_spain_state_key" {
  description = "Remote state key for Spain networking stack"
  type        = string
  default     = "dev/networking/spain/terraform.tfstate"
}

variable "global_cluster_identifier" {
  description = "Aurora global cluster identifier"
  type        = string
  default     = "dev-aurora-global"
}

variable "cluster_name" {
  description = "Aurora cluster name prefix"
  type        = string
  default     = "dev-aurora"
}

variable "engine" {
  description = "Aurora engine"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version" {
  description = "Aurora engine version"
  type        = string
  default     = "16.3"
}

variable "database_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "master_username" {
  description = "Master username for Aurora primary cluster"
  type        = string
  default     = "appadmin"
}

variable "instance_class" {
  description = "Instance class for Aurora instances"
  type        = string
  default     = "db.t4g.medium"
}

variable "instance_count_primary" {
  description = "Number of instances in primary cluster"
  type        = number
  default     = 1
}

variable "instance_count_secondary" {
  description = "Number of instances in secondary cluster"
  type        = number
  default     = 1
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on delete"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = true
}

variable "allowed_cidr_blocks" {
  description = "Additional CIDR blocks allowed to connect to Aurora"
  type        = list(string)
  default     = []
}

variable "route53_private_zone_name" {
  description = "Private Route53 hosted zone name for Aurora endpoints"
  type        = string
  default     = "dev.db.internal"
}

variable "route53_writer_record_name" {
  description = "Record name for Aurora writer endpoint"
  type        = string
  default     = "aurora-writer"
}

variable "route53_reader_record_name" {
  description = "Record name for Aurora reader endpoint"
  type        = string
  default     = "aurora-reader"
}

variable "route53_record_ttl" {
  description = "TTL in seconds for Route53 CNAME records"
  type        = number
  default     = 60
}
