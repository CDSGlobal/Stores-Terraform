provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "QA_hearstukdb" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.3.8"
  instance_class       = "db.t3.medium"
  name                 = "qahearst" #alpha-numberic no signs
  username             = "magento"
  password             = "Cd$Rd$1901" #minimum 8 chars, no @ symbol
  parameter_group_name = "default.mariadb10.3"
  db_subnet_group_name = "default-vpc-19e3497f"
  skip_final_snapshot = "true"
  identifier = "qahearstuk"

  tags {
    Name        = "QA_hearstuk_DB"
    Application = "QA-hearstuk"
  }
}
