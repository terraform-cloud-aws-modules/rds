variable "tags" {}

variable "subnet_ids" {
  type    = list
  default = []
}

variable "rds_clustername" {
  type    = string
}

variable "rds_engine" {
  type    = string
}

variable "rds_az" {
  type    = list
  default = []
}

variable "rds_db_name" {
  type    = string
}

variable "rds_master_user" {
  type    = string
}

variable "rds_master_pw" {
  type    = string
}

variable "rds_backup_retention" {
  type    = string
}

variable "rds_backup_window" {
  type    = string
}
