#!/bin/bash
# Tooling Application User Data Script

# Update system
apt-get update -y
apt-get upgrade -y

# Install Apache and PHP
apt-get install -y \
    apache2 \
    php \
    php-mysql \
    libapache2-mod-php

# Create simple tooling application
cat > /var/www/html/index.php <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Tooling Application</title>
</head>
<body>
    <h1>Tooling Application</h1>
    <p>Status: Running</p>
    <p>Server Time: <?php echo date('Y-m-d H:i:s'); ?></p>
</body>
</html>
EOF

# Create health check
echo "healthy" > /var/www/html/healthstatus

# Set permissions
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/

# Start Apache
systemctl restart apache2
systemctl enable apache2