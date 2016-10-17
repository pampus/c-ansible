    ### wordpress
    cat <<EOF > c-ansible/roles/wordpress/vars/main.yml
    wp_db_name: wordpress
    wp_db_user: wordpress
    wp_db_password: wordpress
    wp_dir: /var/www/html
    mysql_host: localhost
    mysql_port: 3306
    auto_up_disable: false
    core_update_level: true
    EOF
