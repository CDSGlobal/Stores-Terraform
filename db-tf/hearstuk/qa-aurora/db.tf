provider "aws" {
  region = "us-east-1"
}

resource "aws_rds_cluster" "qa-hearstuk" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  database_name           = "qahearstuk" #Only alphanumerics, no dashes
  master_username         = "magento"
  master_password         = "Cd$Rd$1901" #8 characters minimum
  db_subnet_group_name    = "default-vpc-19e3497f"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
}
