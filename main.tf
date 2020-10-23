locals {
	db_creds_password = jsondecode(data.aws_secretsmanager_secret_version.rds_master_pw.secret_string)
}

resource "aws_secretsmanager_secret" "rds_master_pw" {
  name = "${var.rds_clustername}-rds-master-pw"
  recovery_window_in_days = 0

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "rds_master_pw" {
  secret_id      = data.aws_secretsmanager_secret.rds_master_pw.id
  secret_string  = local.db_creds_password
}

data "aws_secretsmanager_secret" "rds_master_pw" {
  arn = aws_secretsmanager_secret.rds_master_pw.arn
}

data "aws_secretsmanager_secret_version" "rds_master_pw" {
	secret_id = data.aws_secretsmanager_secret.rds_master_pw.id
}

resource "aws_rds_cluster" "default" {
  cluster_identifier      = var.rds_clustername
  engine                  = var.rds_engine
  availability_zones      = var.rds_az
  database_name           = var.rds_db_name
  master_username         = var.rds_master_user
  master_password         = local.db_creds_password
  backup_retention_period = var.rds_backup_retention
  preferred_backup_window = var.rds_backup_window
  tags                    = var.tags
}
