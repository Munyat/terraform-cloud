#!/bin/bash
# Base system setup script

set -e  # Exit on error

echo "=== Starting base system setup ==="

# Update system packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install common utilities
sudo apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    htop \
    python3-pip \
    python3-venv \
    awscli

# Install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i amazon-cloudwatch-agent.deb
rm amazon-cloudwatch-agent.deb

# Basic security hardening
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Create common directories
sudo mkdir -p /opt/app /var/log/app
sudo chmod 755 /opt/app /var/log/app

echo "=== Base system setup complete ==="