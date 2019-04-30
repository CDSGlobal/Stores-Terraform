provider "aws" {
    region = "us-east-1"
#us-east-1 North Virginia
#us-east-2 Ohio
#us-west-1 North California
#us-west-2 Oregon
}

resource "aws_instance" "QA_Cap_Deploy" {
  ami                    = "ami-14c5486b" #Amazon Linux AMI, change this to CentOS7 eventually
  instance_type          = "t2.medium"      
  key_name               = "QA_Cap_Deploy"
  vpc_security_group_ids = ["sg-0d40797d"]
  subnet_id              = "subnet-811b7dda"
  private_ip             = "172.26.175.211" #Make sure no one else is using this IP in the console

  # vpc_security_group_ids = ["sg-cf76ccb1"] Sandbox us-west-2
  root_block_device {
    volume_type = "gp2"
    volume_size = 80
  }

  tags {
    Name        = "QA_Cap_Deploy"
    Application = "Stores"
  }
}
