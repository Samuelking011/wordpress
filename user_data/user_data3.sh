#!/bin/bash

sudo systemctl restart nginx

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
