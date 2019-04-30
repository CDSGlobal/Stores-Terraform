provider "aws" {
  region = "us-east-1"
}
resource "aws_db_instance" "m2-integration" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.2.13"
  instance_class       = "db.t2.micro"
  name                 = "int-db"
  username             = "magento"
  password             = "mage911"
  parameter_group_name = "default.mysql5.7"

  tags {
    Name        = "stores-integration-test"
    Application = "integration"
  }
}
