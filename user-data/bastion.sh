#!/bin/bash
# Bastion User Data Script

# Update system
apt-get update -y
apt-get upgrade -y

# Install basic tools
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    htop \
    nginx

# Configure SSH (optional security hardening)
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

# Create custom message
echo "Bastion Host Ready!" > /var/www/html/index.html