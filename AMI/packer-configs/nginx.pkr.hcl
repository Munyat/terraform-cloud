# AMI/packer-configs/nginx.pkr.hcl

build {
  name = "nginx"
  sources = [
    "source.amazon-ebs.ubuntu-22-04"
  ]

  provisioner "file" {
    source      = "${path.root}/scripts/base-setup.sh"
    destination = "/tmp/base-setup.sh"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/install-nginx.sh"
    destination = "/tmp/install-nginx.sh"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/cleanup.sh"
    destination = "/tmp/cleanup.sh"
  }

  # Base setup
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/base-setup.sh",
      "sudo /tmp/base-setup.sh"
    ]
  }

  # Install Nginx
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/install-nginx.sh",
      "sudo /tmp/install-nginx.sh"
    ]
  }

  # Create Nginx configuration template
  provisioner "file" {
    content = <<-EOF
      server {
          listen 80;
          server_name _;
          
          location / {
              proxy_pass http://${var.internal_alb_dns};
              proxy_set_header Host $$host;
              proxy_set_header X-Real-IP $$remote_addr;
              proxy_set_header X-Forwarded-For $$proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $$scheme;
          }
          
          location /health {
              access_log off;
              return 200 "healthy\\n";
              add_header Content-Type text/plain;
          }
      }
    EOF
    destination = "/tmp/nginx-reverse-proxy.conf"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/nginx-reverse-proxy.conf /etc/nginx/sites-available/default",
      "sudo systemctl restart nginx"
    ]
  }

  # Cleanup
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/cleanup.sh",
      "sudo /tmp/cleanup.sh"
    ]
  }
}