# AMI/packer-configs/bastion.pkr.hcl

# Include shared configurations
locals {
  # This file will be merged with others in the directory
}

# Build configuration
build {
  name = "bastion"
  sources = [
    "source.amazon-ebs.ubuntu-22-04"
  ]

  # Upload scripts
  provisioner "file" {
    source      = "${path.root}/scripts/base-setup.sh"
    destination = "/tmp/base-setup.sh"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/cleanup.sh"
    destination = "/tmp/cleanup.sh"
  }

  # Run base setup
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/base-setup.sh",
      "sudo /tmp/base-setup.sh"
    ]
  }

  # Bastion-specific configurations
  provisioner "shell" {
    inline = [
      "echo '=== Configuring Bastion Host ==='",
      "# Install additional security tools",
      "sudo apt-get install -y fail2ban ufw",
      
      "# Configure firewall",
      "sudo ufw allow 22/tcp",
      "sudo ufw --force enable",
      
      "# Set up logging",
      "sudo mkdir -p /var/log/bastion",
      "sudo chmod 755 /var/log/bastion"
    ]
  }

  # Final cleanup
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/cleanup.sh",
      "sudo /tmp/cleanup.sh"
    ]
  }

  # Tag the AMI
  post-processor "manifest" {
    output = "manifest-bastion.json"
    strip_path = true
  }
}