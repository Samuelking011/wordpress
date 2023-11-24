#!/bin/bash

# Update the system
sudo yum update -y
sudo yum install expect -y


# Install nginx
sudo amazon-linux-extras list | grep nginx
sudo amazon-linux-extras enable nginx1
sudo yum clean metadata && sudo yum install nginx -y

# Install PHP
sudo amazon-linux-extras list | grep php
sudo amazon-linux-extras enable php8.2
sudo yum clean metadata && sudo yum install yum install php-cli php-pdo php-fpm php-mysqlnd -y

# Start and enable Nginx and PHP-FPM
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl enable php-fpm
sudo systemctl start php-fpm

# Configure Nginx for WordPress
sudo groupadd www-data
sudo usermod -a -G nginx ec2-user
sudo chown -R ec2-user:nginx /usr/share/nginx/html

# Restart the shell
exec bash
