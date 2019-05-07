provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "integration-testing" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.3.8"
  instance_class       = "db.r4.xlarge"
  name                 = "inttesting" #alpha-numberic no signs
  username             = "magento"
  password             = "Cd$mage911" #minimum 8 chars
  parameter_group_name = "default.mariadb10.3"
  db_subnet_group_name = "default-vpc-19e3497f"
  skip_final_snapshot = "true"
  identifier = "inttesting"

  tags {
    Name        = "integration-testing"
    Application = "integration-testing"
  }
}
