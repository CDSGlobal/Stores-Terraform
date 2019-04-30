provider "aws" {
    region = "us-east-1"
#us-east-1 North Virginia
#us-east-2 Ohio
#us-west-1 North California
#us-west-2 Oregon
}

resource "aws_instance" "stores-integration-test" {
  ami                    = "ami-14c5486b" #Amazon Linux AMI, change this to CentOS7 eventually
  instance_type          = "t2.medium"      
  key_name               = "stores-integration-test" #Create this before running terraform commands or server will not create
  vpc_security_group_ids = ["sg-0d40797d"]
  subnet_id              = "subnet-811b7dda" #Depending on this ID your instance may or may not be accessible to certain IP ranges
  private_ip             = "172.26.175.214"  #Make sure no one else is using this IP in the console

  root_block_device {
    volume_type = "gp2"
    volume_size = 80
  }

  tags {
    Name        = "stores-integration-test"
    Application = "integration"
  }

  user_data = <<HEREDOC
  #!/bin/bash

  echo "===> Installing PHP 71"
  yum install -y php71-mcrypt php71-gd php71 php71-opcache php71-cli php71-common php71-gd php71-mbstring php71-mcrypt php71-pdo php71-xml php71-mysqlnd php71-bcmath php71-ctype php71-dom php71-mhash php71-mcrypt php71-curl php71-intl php71-xsl php71-openssl php71-zip php71-soap php71-pecl-xdebug

  echo "===> Downloading composer installer"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

  echo "===> Installing composer"
  sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

  echo "===> Installing git"
  yum -y install git

  echo "===> Cloning git repository"
  sudo mkdir /opt/aws/m2/
  sudo git clone https://cds-magento2:6b952e1b42b6260378e0e58ae83a62a10d12b5a9@github.com/CDSGlobal/m2-module-authorization.git /opt/aws/m2

  echo "===> Public key of machine"
  cat ~/.ssh/id_rsa.pub
HEREDOC
}
