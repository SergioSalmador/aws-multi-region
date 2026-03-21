output "global_cluster_id" {
  value = aws_rds_global_cluster.this.id
}

output "primary_cluster_id" {
  value = module.aurora_primary.cluster_id
}

output "primary_cluster_arn" {
  value = module.aurora_primary.cluster_arn
}

output "primary_cluster_endpoint" {
  value = module.aurora_primary.cluster_endpoint
}

output "primary_cluster_reader_endpoint" {
  value = module.aurora_primary.cluster_reader_endpoint
}

output "secondary_cluster_id" {
  value = module.aurora_secondary.cluster_id
}

output "secondary_cluster_arn" {
  value = module.aurora_secondary.cluster_arn
}

output "secondary_cluster_endpoint" {
  value = module.aurora_secondary.cluster_endpoint
}

output "secondary_cluster_reader_endpoint" {
  value = module.aurora_secondary.cluster_reader_endpoint
}

output "failover_note" {
  value = "Aurora Global Database supports cross-region failover/switchover operations. Execute failover command and then switch app endpoint/DNS if needed."
}

output "global_failover_command" {
  value = "aws rds failover-global-cluster --global-cluster-identifier ${aws_rds_global_cluster.this.id} --target-db-cluster-identifier ${module.aurora_secondary.cluster_arn} --region ${var.ireland_region}"
}
