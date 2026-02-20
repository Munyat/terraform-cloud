#!/bin/bash
# Clean up the image before creating AMI

echo "=== Cleaning up ==="

# Remove temporary files
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Clean package cache
sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt-get clean

# Clear bash history
history -c
cat /dev/null > ~/.bash_history

# Remove SSH host keys (will be regenerated on first boot)
sudo rm -f /etc/ssh/ssh_host_*

# Remove machine ID (will be regenerated on first boot)
sudo rm -f /etc/machine-id
sudo touch /etc/machine-id

echo "=== Cleanup complete ==="