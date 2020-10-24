resource "aws_secretsmanager_secret" "this" {
  name = "${var.rds_clustername}-${var.rds_master_user}-pw"
  recovery_window_in_days = 0

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id      = aws_secretsmanager_secret.this.id
  secret_string  = random_password.rds_password.result
}

resource "random_password" "rds_password" {
  length  = var.rds_password_length
  special = false
}

resource "aws_rds_cluster" "default" {
  cluster_identifier      = var.rds_clustername
  engine                  = var.rds_engine
  availability_zones      = var.rds_az
  database_name           = var.rds_db_name
  master_username         = var.rds_master_user
  master_password         = random_password.rds_password.result
  backup_retention_period = var.rds_backup_retention
  preferred_backup_window = var.rds_backup_window
  skip_final_snapshot     = var.rds_final_snapshot
  tags                    = var.tags
}

resource "aws_rds_cluster_instance" "default" {
  count                   = var.rds_instance_count
  identifier              = "${var.rds_clustername}-${count.index}"
  cluster_identifier      = aws_rds_cluster.default.id
  instance_class          = var.rds_instance_class
  engine                  = aws_rds_cluster.default.engine
  engine_version          = aws_rds_cluster.default.engine_version
  tags                    = var.tags
}
