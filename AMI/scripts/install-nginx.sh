#!/bin/bash
# Install and configure Nginx

set -e

echo "=== Installing Nginx ==="

# Install Nginx
sudo apt-get install -y nginx

# Create custom index page
cat > /tmp/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Nginx</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #333; }
    </style>
</head>
<body>
    <h1>Nginx is running!</h1>
    <p>Server: $(hostname -f)</p>
    <p>Time: $(date)</p>
</body>
</html>
EOF

sudo cp /tmp/index.html /var/www/html/index.html

# Create health check endpoint
echo "healthy" | sudo tee /var/www/html/health

# Start and enable Nginx
sudo systemctl enable nginx
sudo systemctl start nginx

echo "=== Nginx installation complete ==="