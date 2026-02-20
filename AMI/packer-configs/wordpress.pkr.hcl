# AMI/packer-configs/wordpress.pkr.hcl

build {
  name = "wordpress"
  sources = [
    "source.amazon-ebs.ubuntu-22-04"
  ]

  provisioner "file" {
    source      = "${path.root}/scripts/base-setup.sh"
    destination = "/tmp/base-setup.sh"
  }

  provisioner "file" {
    source      = "${path.root}/scripts/install-wordpress.sh"
    destination = "/tmp/install-wordpress.sh"
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

  # Install WordPress
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/install-wordpress.sh",
      "sudo /tmp/install-wordpress.sh"
    ]
  }

  # Create WordPress wp-config template
  provisioner "file" {
    content = <<-EOF
      <?php
      define('DB_NAME', '${var.db_name}');
      define('DB_USER', '${var.db_user}');
      define('DB_PASSWORD', '${var.db_password}');
      define('DB_HOST', '${var.db_host}');
      define('DB_CHARSET', 'utf8');
      define('DB_COLLATE', '');
      
      define('AUTH_KEY',         '${var.auth_key}');
      define('SECURE_AUTH_KEY',  '${var.secure_auth_key}');
      define('LOGGED_IN_KEY',    '${var.logged_in_key}');
      define('NONCE_KEY',        '${var.nonce_key}');
      define('AUTH_SALT',        '${var.auth_salt}');
      define('SECURE_AUTH_SALT', '${var.secure_auth_salt}');
      define('LOGGED_IN_SALT',   '${var.logged_in_salt}');
      define('NONCE_SALT',       '${var.nonce_salt}');
      
      $table_prefix = 'wp_';
      
      define('WP_DEBUG', false);
      
      if ( !defined('ABSPATH') ) {
          define('ABSPATH', __DIR__ . '/');
      }
      
      require_once ABSPATH . 'wp-settings.php';
      EOF
    destination = "/tmp/wp-config-sample.php"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/wp-config-sample.php /var/www/wordpress/wp-config-sample.php"
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