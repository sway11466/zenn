#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# install apache
yum install httpd -y
systemctl start httpd

# install php
amazon-linux-extras enable php7.4
yum install php php-gd php-mysqlnd php-xmlrpc -y

# install wordpress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
#cp wordpress/wp-config-sample.php wordpress/wp-config.php
cp -r wordpress/* /var/www/html/
systemctl restart httpd

# setting wordpress
chown -R apache /var/www
chgrp -R apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
