    ### wordpress
    cat <<EOF > c-ansible/roles/wordpress/vars/main.yml
    wp_version: 4.2.4
    wp_sha256sum: 42ca594afc709cbef8528a6096f5a1efe96dcf3164e7ce321e87d57ae015cc82
    wp_db_name: wordpress
    wp_db_user: wordpress
    wp_db_password: secret
    wp_dir: /var/www/html
    mysql_host: localhost
    mysql_port: 3306
    EOF
