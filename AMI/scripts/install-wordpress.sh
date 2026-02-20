#!/bin/bash
# Install WordPress with dependencies

set -e

echo "=== Installing WordPress dependencies ==="

# Install Apache and PHP
sudo apt-get install -y \
    apache2 \
    php \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-xmlrpc \
    php-soap \
    php-intl \
    php-zip \
    libapache2-mod-php

# Download WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

# Prepare web root
sudo mkdir -p /var/www/wordpress
sudo cp -r wordpress/* /var/www/wordpress/
sudo chown -R www-data:www-data /var/www/wordpress
sudo chmod -R 755 /var/www/wordpress

# Create Apache virtual host
cat > /tmp/wordpress.conf << 'EOF'
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/wordpress
    
    <Directory /var/www/wordpress>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo mv /tmp/wordpress.conf /etc/apache2/sites-available/wordpress.conf
sudo a2ensite wordpress.conf
sudo a2dissite 000-default.conf
sudo systemctl restart apache2

# Create health check
echo "healthy" | sudo tee /var/www/wordpress/health

echo "=== WordPress installation complete ==="