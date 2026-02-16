#!/bin/bash
# WordPress User Data Script

# Update system
apt-get update -y
apt-get upgrade -y

# Install Apache and PHP
apt-get install -y \
    apache2 \
    php \
    php-mysql \
    libapache2-mod-php \
    php-cli \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-xmlrpc \
    php-soap \
    php-intl \
    php-zip

# Download and configure WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
cp -r wordpress/* /var/www/html/

# Set permissions
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/

# Create health check file
echo "healthy" > /var/www/html/healthstatus

# Start Apache
systemctl restart apache2
systemctl enable apache2