provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "m2-integration" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.3.8"
  instance_class       = "db.t2.micro"
  name                 = "intdb" #alpha-numberic no signs
  username             = "magento"
  password             = "Cd$mage911" #minimum 8 chars
  parameter_group_name = "default.mariadb10.3"
  db_subnet_group_name = "default-vpc-fd5a909b"
  final_snapshot_identifier = "finaldb"
  identifier = "intdb"

  tags {
    Name        = "stores-integration-test"
    Application = "integration"
  }
}
