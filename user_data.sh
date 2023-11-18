#!/bin/bash

# Update the system
sudo yum update -y

# Install Nginx
sudo yum install -y epel-release
sudo yum install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Install PHP and MySQL
sudo yum install -y php php-fpm php-mysqlnd

# Start and enable PHP-FPM
sudo systemctl start php-fpm
sudo systemctl enable php-fpm

# Install MySQL
sudo yum install -y mysql-server

# Start and enable MySQL
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Run MySQL secure installation
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
sudo cp -R wordpress/* /usr/share/nginx/html/
sudo chown -R nginx:nginx /usr/share/nginx/html/
sudo rm -rf wordpress latest.tar.gz

# Create Nginx virtual host configuration for WordPress
sudo tee /etc/nginx/conf.d/wordpress.conf > /dev/null <<EOL
server {
    listen 80;
    server_name your_domain_or_ip;

    root /usr/share/nginx/html;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        try_files \$uri =404;
        fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    error_page 404 /404.html;
    location = /404.html {
        root /usr/share/nginx/html;
        internal;
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
        internal;
    }
}
EOL

# Restart Nginx
sudo systemctl restart nginx
