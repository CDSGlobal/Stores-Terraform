provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "QA_Bauer-db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.3.8"
  instance_class       = "db.t3.medium"
  name                 = "qabauer" #alpha-numberic no signs
  username             = "magento"
  password             = "Cd$Bau3r1901" #minimum 8 chars, no @ symbol
  parameter_group_name = "default.mariadb10.3"
  db_subnet_group_name = "default-vpc-19e3497f"
  skip_final_snapshot = "true"
  identifier = "qabauer"

  tags {
    Name        = "QA_Bauer_DB"
    Application = "QA-Bauer"
  }
}
