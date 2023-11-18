#!/bin/bash

# Update the system
sudo yum update -y
sudo yum install expect -y


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
sudo groupadd www-data
sudo usermod -a -G nginx ec2-user
sudo chown -R ec2-user:nginx /usr/share/nginx/html
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
y
password
password
y
y
y
y
EOF

# Create WordPress database
nano create_database.sh
# Database credentials
DB_USER="root"
DB_PASSWORD="password"  # Replace with your actual MariaDB root password
DB_NAME="wordpress"      # Replace with your desired database name

# SQL commands to create the database
SQL_COMMANDS="CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;"

# Execute SQL commands using the mysql command
mysql -u$DB_USER -p$DB_PASSWORD -e "$SQL_COMMANDS"

# Check if the database creation was successful
if [ $? -eq 0 ]; then
    echo "Database $DB_NAME created successfully."
else
    echo "Error: Failed to create database $DB_NAME."
fi

# Use expect to send keypresses to the terminal
expect <<EOF
spawn nano
send "\x18"  # Ctrl+X
send "Y"     # Y for Yes (to confirm save)
send "\r"    # Enter
expect eof   # Wait for the process to finish
EOF

chmod +x create_database.sh
./create_database.sh




# Download and configure WordPress
wget https://wordpress.org/latest.zip
unzip latest.zip
mv wordpress/* /usr/share/nginx/html
sudo chown -R ec2-user:nginx /usr/share/nginx/html
rm -rf wordpress

#Configure WordPress
cd /usr/share/nginx/html
cp wp-config-sample.php wp-config.php
cd
nano config_update.sh
config_file="/usr/share/nginx/html/wp-config.php"

# Replace database_name_here with dbase
sed -i "s/database_name_here/wordpress/g" "$config_file"

# Replace username_here with root
sed -i "s/username_here/root/g" "$config_file"

# Replace password_here with the password you set earlier
sed -i "s/password_here/password/g" "$config_file"

# Use expect to send keypresses to the terminal
expect <<EOF
spawn nano
send "\x18"  # Ctrl+X
send "Y"     # Y for Yes (to confirm save)
send "\r"    # Enter
expect eof   # Wait for the process to finish
EOF

chmod +x config_update.sh
./config_update.sh



