#!/bin/bash
# Nginx Reverse Proxy User Data Script

# Update system
apt-get update -y
apt-get upgrade -y

# Install nginx
apt-get install -y nginx

# Configure nginx as reverse proxy
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://${aws_lb.ialb.dns_name};
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /healthstatus {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
EOF

# Start nginx
systemctl restart nginx
systemctl enable nginx