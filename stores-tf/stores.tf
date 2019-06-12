provider "aws" {
    region = "us-east-1"
#us-east-1 North Virginia
#us-east-2 Ohio
#us-west-1 North California
#us-west-2 Oregon
}

resource "aws_instance" "stores-tf" {
  ami                    = "ami-01be326d846e4b0eb" #Official CentOS76 AMI from The CentOS Project
  instance_type          = "t2.small"      
  key_name               = "stores-tf" #Name of the private key, don't forget to create this on the console to ssh in
  vpc_security_group_ids = ["sg-0d40797d"] #Security Group created specifically for Magento 2
  subnet_id              = "subnet-811b7dda"
  private_ip             = "172.26.175.218" #Make sure no one else is using this IP in the console
  iam_instance_profile   = "S3AdminAccess" #Allow access to S3 buckets to pull http file

  root_block_device {
    volume_type = "gp2"
    volume_size = 80
  }

  tags {
    Name        = "stores-tf"
    Application = "Stores"
  }

user_data = <<HEREDOC
#!/bin/bash
echo "====> Updating OS"
sudo yum update -y
echo "====> Installing HTTPD"
sudo yum install httpd -y
echo "====> Turn HTTPD on"
sudo systemctl start httpd
echo "====> Install wget"
sudo yum install wget -y
echo "====> Installing EPEL (This did not appear to do much, atleast not php-wise)"
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
echo "====> Installing VIM"
sudo yum install vim-enhanced -y
echo "====> Installing Git"
sudo yum install git -y
echo "====> Installing PHP repo"
sudo yum install -y http://dl.iuscommunity.org/pub/ius/stable/CentOS/7/x86_64/ius-release-1.0-15.ius.centos7.noarch.rpm yum -y update
echo "====> Installing PHP"
sudo yum install php72u php72u-pdo php72u-mysqlnd php72u-opcache php72u-xml php72u-gd php72u-devel php72u-mysql php72u-intl php72u-mbstring php72u-bcmath php72u-json php72u-iconv php72u-soap -y
echo "====> Installing locate"
sudo yum install mlocate -y
echo "====> Get Composer installer"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
echo "====> Installing Composer"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
echo "====> Authorize Packagist with token"
composer config --global --auth http-basic.repo.packagist.com cds-magento2 0b5e6fe330413dd1145dbd8f20d1095fc36106d9fe97be0aca45a46d569f
echo "====> Creating mageuser"
sudo adduser mageuser
echo "====> Creating magegroup"
sudo groupadd magegroup
echo "====> Adding mageuser to magegroup"
sudo usermod -a -G magegroup mageuser
echo "====> Adding docroot"
sudo mkdir -p /opt/magento/docroot
echo "====> Change permissions of docroot"
sudo chown -R mageuser:magegroup /opt/magento/*
echo "====> Change permissions to 755"
sudo chmod 755 -R /opt/magento/*
echo "====> Installing unzip utility"
sudo yum install unzip -y
echo "====> Download aws-cli installer"
sudo curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
echo "====> Unzip aws-cli installer contents"
sudo unzip awscli-bundle.zip
echo "====> Run the install executable"
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
echo "====> Get httpd.conf from S3"
aws s3 cp s3://testbucketdamir/httpd.conf .
echo "====> Get Terraform zip"
wget https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip
echo "====> Put Terraform in your path"
sudo cp terraform /usr/local/bin/
HEREDOC
}
