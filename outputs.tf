output "this_rds_cluster_arn" {
  description = "The ID of the cluster"
  value       = aws_rds_cluster.default.arn
}

output "this_rds_cluster_id" {
  description = "The ID of the cluster"
  value       = aws_rds_cluster.default.id
}

output "this_rds_cluster_resource_id" {
  description = "The Resource ID of the cluster"
  value       = aws_rds_cluster.default.cluster_resource_id
}

output "this_rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.default.endpoint
}

output "this_rds_cluster_engine_version" {
  description = "The cluster engine version"
  value       = aws_rds_cluster.default.engine_version
}

output "this_rds_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.default.reader_endpoint
}
