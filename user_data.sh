#!/bin/bash

# Update the system
sudo yum update -y

# Install nginx
sudo amazon-linux-extras list | grep nginx
sudo amazon-linux-extras enable nginx1
sudo yum clean metadata && sudo yum install nginx -y

# Install PHO
sudo amazon-linux-extras list | grep php
sudo amazon-linux-extras enable php8.2
sudo yum clean metadata && sudo yum install yum install php-cli php-pdo php-fpm php-mysqlnd -y

# Start and enable Nginx and PHP-FPM
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl start php-fpm
sudo systemctl enable php-fpm

# Configure Nginx for WordPress
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
sudo wget -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/nginx/nginx/master/conf/nginx.conf
sudo sed -i 's/\/var\/www\/html/\/usr\/share\/nginx\/html\/wordpress/g' /etc/nginx/nginx.conf
sudo systemctl restart nginx

# Install and configure MariaDB
sudo amazon-linux-extras list | grep mariadb
sudo amazon-linux-extras enable mariadb10.5
sudo yum clean metadata && sudo yum install mariadb -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
sudo mysql_secure_installation <<EOF

y
password
password
y
y
y
y
EOF

# Create WordPress database and user
sudo mysql -u root -ppassword -e "CREATE DATABASE wordpress;"
sudo mysql -u root -ppassword -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';"
sudo mysql -u root -ppassword -e "FLUSH PRIVILEGES;"

# Download and configure WordPress
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo mv wordpress /usr/share/nginx/html/
sudo chown -R nginx:nginx /usr/share/nginx/html/wordpress

# Cleanup
sudo rm -f latest.tar.gz

# Display the WordPress login URL
echo "WordPress installation completed."
echo "You can access WordPress at http://<your-ec2-public-ip>/wordpress"
