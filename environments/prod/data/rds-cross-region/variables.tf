variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
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
  default     = "prod/networking/ireland/terraform.tfstate"
}

variable "networking_spain_state_key" {
  description = "Remote state key for Spain networking stack"
  type        = string
  default     = "prod/networking/spain/terraform.tfstate"
}

variable "global_cluster_identifier" {
  description = "Aurora global cluster identifier"
  type        = string
  default     = "prod-aurora-global"
}

variable "cluster_name" {
  description = "Aurora cluster name prefix"
  type        = string
  default     = "prod-aurora"
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
  default     = "db.r6g.large"
}

variable "instance_count_primary" {
  description = "Number of instances in primary cluster"
  type        = number
  default     = 2
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
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on delete"
  type        = bool
  default     = false
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
